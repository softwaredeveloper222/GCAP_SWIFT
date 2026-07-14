//
//  AppDelegate.swift
//  GCAP
//

import UIKit
import OneSignalFramework

final class AppDelegate: NSObject, UIApplicationDelegate, OSNotificationClickListener {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        guard OneSignalConfig.isConfigured else {
            NSLog("[OneSignal] App ID not configured — push disabled")
            return true
        }

        // Verbose logs — filter Xcode console for OneSignal
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize(OneSignalConfig.appId, withLaunchOptions: launchOptions)
        OneSignal.Notifications.addClickListener(self)
        NSLog("[OneSignal] initialized appId=%@", OneSignalConfig.appId)

        // Permission is requested after splash (see GCAPApp / PushPermissionRequester)

        return true
    }

    func onClick(event: OSNotificationClickEvent) {
        let data = event.notification.additionalData
        let type = (data?["type"] as? String) ?? ""
        guard type == "safety_days" else { return }

        Task { @MainActor in
            PushNavigationStore.shared.openSafetyDays()
        }
    }
}
