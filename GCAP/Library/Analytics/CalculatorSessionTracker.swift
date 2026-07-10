//
//  CalculatorSessionTracker.swift
//  GCAP
//

import Foundation
import Combine

final class CalculatorSessionTracker: ObservableObject {
    private let calculatorId: String
    private let sessionId = UUID().uuidString
    private var startedAt: Date?
    private var lastCalculationAt: Date = .distantPast
    private let debounceInterval: TimeInterval = 0.5
    private var didEndSession = false

    init(calculatorId: String) {
        self.calculatorId = calculatorId
    }

    func onAppear() {
        // Keep the same session if SwiftUI re-calls onAppear without a real leave.
        guard startedAt == nil else { return }
        didEndSession = false
        CalculatorAnalytics.shared.initIfNeeded()
        startedAt = Date()
        CalculatorAnalytics.shared.trackOpened(calculatorId: calculatorId, sessionId: sessionId)
    }

    func onDisappear() {
        guard !didEndSession, let startedAt else { return }
        didEndSession = true
        let durationMs = Int64(Date().timeIntervalSince(startedAt) * 1000)
        CalculatorAnalytics.shared.trackSessionEnd(
            calculatorId: calculatorId,
            sessionId: sessionId,
            durationMs: durationMs
        )
        self.startedAt = nil
    }

    func trackCalculation(success: Bool) {
        let now = Date()
        guard now.timeIntervalSince(lastCalculationAt) >= debounceInterval else { return }
        lastCalculationAt = now
        CalculatorAnalytics.shared.initIfNeeded()
        CalculatorAnalytics.shared.trackCalculation(
            calculatorId: calculatorId,
            sessionId: sessionId,
            success: success
        )
    }

    func trackError() {
        CalculatorAnalytics.shared.initIfNeeded()
        CalculatorAnalytics.shared.trackError(calculatorId: calculatorId, sessionId: sessionId)
    }
}
