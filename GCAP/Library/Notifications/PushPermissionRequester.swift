//
//  PushPermissionRequester.swift
//  GCAP
//

import Foundation
import OneSignalFramework

enum PushPermissionRequester {
    /// Ask for notification permission after the splash screen has dismissed.
    static func requestAfterSplash() {
        guard OneSignalConfig.isConfigured else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            OneSignal.Notifications.requestPermission({ accepted in
                NSLog("[OneSignal] Permission accepted: \(accepted)")
            }, fallbackToSettings: false)
        }
    }
}
