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

                // Match Android: ensure push subscription is opted in after the prompt.
                OneSignal.User.pushSubscription.optIn()
                let sub = OneSignal.User.pushSubscription
                NSLog(
                    "[OneSignal] pushSubscription id=%@ token=%@ optedIn=%@",
                    sub.id ?? "nil",
                    sub.token ?? "nil",
                    String(describing: sub.optedIn)
                )
            }, fallbackToSettings: true)
        }
    }
}
