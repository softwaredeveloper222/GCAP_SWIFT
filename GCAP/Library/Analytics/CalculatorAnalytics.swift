//
//  CalculatorAnalytics.swift
//  GCAP
//

import Foundation

final class CalculatorAnalytics {
    static let shared = CalculatorAnalytics()

    private let prefsKeyDeviceId = "calculator_analytics_device_id"
    private let prefsKeyPending = "calculator_analytics_pending_events"
    private let queue = DispatchQueue(label: "com.gcap.calculator_analytics")

    private var deviceId: String = ""
    private var deviceInfo: DeviceInfo = DeviceInfo.current()
    private var isSending = false
    private var didInit = false

    private init() {}

    func initIfNeeded() {
        queue.sync {
            guard !didInit else { return }
            didInit = true
            deviceId = getOrCreateDeviceId()
            deviceInfo = DeviceInfo.current()
        }
        flushPendingEvents()
    }

    func trackOpened(calculatorId: String, sessionId: String) {
        send(baseEvent(event: "calculator_opened", calculatorId: calculatorId, sessionId: sessionId))
    }

    func trackCalculation(calculatorId: String, sessionId: String, success: Bool) {
        send(baseEvent(
            event: "calculator_calculation",
            calculatorId: calculatorId,
            sessionId: sessionId,
            success: success
        ))
    }

    func trackSessionEnd(calculatorId: String, sessionId: String, durationMs: Int64) {
        send(baseEvent(
            event: "calculator_session_end",
            calculatorId: calculatorId,
            sessionId: sessionId,
            durationMs: durationMs
        ))
    }

    func trackError(calculatorId: String, sessionId: String) {
        send(baseEvent(
            event: "calculator_error",
            calculatorId: calculatorId,
            sessionId: sessionId,
            success: false
        ))
    }

    private func baseEvent(
        event: String,
        calculatorId: String,
        sessionId: String,
        durationMs: Int64? = nil,
        success: Bool? = nil
    ) -> AnalyticsEventPayload {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return AnalyticsEventPayload(
            event: event,
            calculatorId: calculatorId,
            sessionId: sessionId,
            deviceId: deviceId,
            appVersion: version,
            platform: "ios",
            deviceManufacturer: deviceInfo.manufacturer,
            deviceModel: deviceInfo.model,
            deviceBrand: deviceInfo.brand,
            osVersion: deviceInfo.osVersion,
            durationMs: durationMs,
            success: success
        )
    }

    private func send(_ event: AnalyticsEventPayload) {
        guard AnalyticsConfig.enabled else { return }
        initIfNeeded()
        enqueuePending(event)
        flushPendingEvents()
    }

    private func enqueuePending(_ event: AnalyticsEventPayload) {
        queue.sync {
            var pending = loadPendingEvents()
            pending.append(event)
            savePendingEvents(pending)
        }
    }

    private func flushPendingEvents() {
        guard AnalyticsConfig.enabled else { return }

        let pending: [AnalyticsEventPayload] = queue.sync {
            if isSending { return [] }
            let events = loadPendingEvents()
            if events.isEmpty { return [] }
            isSending = true
            return events
        }

        guard !pending.isEmpty else { return }

        guard let url = URL(string: AnalyticsConfig.baseURL + "api/events") else {
            queue.sync { isSending = false }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(AnalyticsConfig.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(AnalyticsIngestPayload(events: pending))
        } catch {
            queue.sync { isSending = false }
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let self else { return }

            self.queue.sync { self.isSending = false }

            if error != nil {
                return
            }

            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                return
            }

            self.queue.sync {
                let remaining = self.loadPendingEvents()
                if remaining.count >= pending.count {
                    self.savePendingEvents(Array(remaining.dropFirst(pending.count)))
                } else {
                    self.savePendingEvents([])
                }
            }

            self.flushPendingEvents()
        }.resume()
    }

    private func getOrCreateDeviceId() -> String {
        let defaults = UserDefaults.standard
        if let existing = defaults.string(forKey: prefsKeyDeviceId) {
            return existing
        }
        let id = UUID().uuidString
        defaults.set(id, forKey: prefsKeyDeviceId)
        return id
    }

    private func loadPendingEvents() -> [AnalyticsEventPayload] {
        guard let data = UserDefaults.standard.data(forKey: prefsKeyPending) else { return [] }
        return (try? JSONDecoder().decode([AnalyticsEventPayload].self, from: data)) ?? []
    }

    private func savePendingEvents(_ events: [AnalyticsEventPayload]) {
        let data = (try? JSONEncoder().encode(events)) ?? Data()
        UserDefaults.standard.set(data, forKey: prefsKeyPending)
    }
}
