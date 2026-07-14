//
//  SafetyDaysNotificationService.swift
//  GCAP
//

import Foundation

@MainActor
final class SafetyDaysNotificationService: ObservableObject {
    static let shared = SafetyDaysNotificationService()

    @Published private(set) var payload: SafetyDaysPublicResponse?
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: String?
    @Published private(set) var hasUnreadUpdate = false
    @Published private(set) var lastFetchFromNetwork = false

    private let cacheKey = "safety_days_cached_payload"
    private let seenVersionKey = "safety_days_seen_version"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private init() {
        loadCache()
        refreshUnreadFlag()
    }

    func refresh() async {
        guard AnalyticsConfig.enabled else { return }
        guard let url = URL(string: AnalyticsConfig.baseURL + "api/notifications/safety-days/public") else {
            lastError = "Invalid notification URL"
            return
        }

        isLoading = true
        defer { isLoading = false }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.setValue("Bearer \(AnalyticsConfig.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard (200...299).contains(status) else {
                lastError = "Server returned \(status)"
                lastFetchFromNetwork = false
                NSLog("[SafetyDaysNotify] Fetch failed: \(status)")
                return
            }

            let decoded = try decoder.decode(SafetyDaysPublicResponse.self, from: data)
            payload = decoded
            saveCache(decoded)
            refreshUnreadFlag()
            lastError = nil
            lastFetchFromNetwork = true
            NSLog(
                "[SafetyDaysNotify] Loaded version \(decoded.version) with \(decoded.content.galleryImages.count) images"
            )
        } catch {
            lastError = error.localizedDescription
            lastFetchFromNetwork = false
            NSLog("[SafetyDaysNotify] Network error: \(error.localizedDescription)")
        }
    }

    func markSeen() {
        guard let version = payload?.version else { return }
        UserDefaults.standard.set(version, forKey: seenVersionKey)
        refreshUnreadFlag()
    }

    private func refreshUnreadFlag() {
        let seen = UserDefaults.standard.integer(forKey: seenVersionKey)
        hasUnreadUpdate = (payload?.version ?? 0) > seen
    }

    private func loadCache() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return }
        do {
            payload = try decoder.decode(SafetyDaysPublicResponse.self, from: data)
        } catch {
            UserDefaults.standard.removeObject(forKey: cacheKey)
        }
    }

    private func saveCache(_ payload: SafetyDaysPublicResponse) {
        do {
            let data = try encoder.encode(payload)
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            NSLog("[SafetyDaysNotify] Failed to cache payload: \(error)")
        }
    }
}
