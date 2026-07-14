//
//  AppDelegate.swift
//  GCAP
//

import UIKit
import OneSignalFramework

final class AppDelegate: NSObject, UIApplicationDelegate, OSNotificationClickListener, OSNotificationLifecycleListener {
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
        OneSignal.Notifications.addForegroundLifecycleListener(self)
        NSLog("[OneSignal] initialized appId=%@", OneSignalConfig.appId)

        // Permission is requested after splash (see GCAPApp / PushPermissionRequester)

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // After a background push, refresh so the New badge can appear from CMS version.
        Task { @MainActor in
            await SafetyDaysNotificationService.shared.refresh()
        }
    }

    // MARK: - Foreground notification (badge immediately)

    func onWillDisplay(event: OSNotificationWillDisplayEvent) {
        handleIncomingSafetyDaysPush(additionalData: event.notification.additionalData)
        // Leave default display behavior (do not call preventDefault).
    }

    // MARK: - Notification tap

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
            SafetyDaysNotificationService.shared.markUnreadFromPush(contentId: contentId)
            PushNavigationStore.shared.openSafetyDays(contentId: contentId)
        }
    }

    private func handleIncomingSafetyDaysPush(additionalData: [AnyHashable: Any]?) {
        let type = (additionalData?["type"] as? String) ?? ""
        guard type == "safety_days" else { return }

        let contentId = Self.contentId(from: additionalData)
        NSLog(
            "[OneSignal] safety_days received (foreground) contentId=%@",
            contentId ?? "(none)"
        )

        Task { @MainActor in
            SafetyDaysNotificationService.shared.markUnreadFromPush(contentId: contentId)
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
