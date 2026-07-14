//
//  OneSignalConfig.swift
//  GCAP
//

import Foundation

enum OneSignalConfig {
    /// OneSignal App ID from dashboard Keys & IDs (same as Android).
    static let appId = "3acc100c-877e-49d4-9a51-d65fa4e77c86"

    static var isConfigured: Bool {
        let trimmed = appId.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed != "YOUR_ONESIGNAL_APP_ID"
    }
}
