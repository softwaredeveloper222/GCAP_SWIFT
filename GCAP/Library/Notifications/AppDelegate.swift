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

        let contentId = Self.contentId(from: data)
        NSLog(
            "[OneSignal] safety_days click contentId=%@",
            contentId ?? "(none)"
        )

        Task { @MainActor in
            PushNavigationStore.shared.openSafetyDays(contentId: contentId)
        }
    }

    private static func contentId(from data: [AnyHashable: Any]?) -> String? {
        guard let data else { return nil }
        for key in ["contentId", "id"] {
            if let value = data[key] as? String {
                let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty { return trimmed }
            }
            if let value = data[key] as? NSNumber {
                return value.stringValue
            }
        }
        return nil
    }
}
