//
//  AppDelegate.swift
//  GCAP
//

import UIKit
import OneSignalFramework

final class AppDelegate: NSObject, UIApplicationDelegate, OSNotificationClickListener,
    OSNotificationLifecycleListener
{
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        guard OneSignalConfig.isConfigured else {
            NSLog("[OneSignal] App ID not configured — push disabled")
            return true
        }

        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize(OneSignalConfig.appId, withLaunchOptions: launchOptions)
        OneSignal.Notifications.addForegroundLifecycleListener(self)
        OneSignal.Notifications.addClickListener(self)
        NSLog("[OneSignal] initialized appId=%@", OneSignalConfig.appId)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Task { @MainActor in
            // Android NSE equivalent when a Safety Days push is already in the tray.
            SafetyDaysNotificationService.shared.syncUnreadFromDeliveredNotifications()
            SafetyDaysNotificationService.shared.reloadUnreadFlag()
        }
    }

    // MARK: - OSNotificationLifecycleListener (foreground receive)

    func onWillDisplay(event: OSNotificationWillDisplayEvent) {
        let data = event.notification.additionalData as? [String: Any]
        guard SafetyDaysNotificationService.isSafetyDaysPush(data) else {
            // Still show non–Safety Days pushes while the app is open.
            event.notification.display()
            return
        }

        let contentId = SafetyDaysNotificationService.contentId(from: data)
        let onesignalId = event.notification.notificationId
        NSLog("[OneSignal] foreground push contentId=%@", contentId ?? "(none)")

        Task { @MainActor in
            SafetyDaysNotificationService.shared.markPushArrived(
                contentId: contentId,
                onesignalId: onesignalId
            )
        }
        // OneSignal 5+: must call display() for a foreground banner.
        event.notification.display()
    }

    // MARK: - OSNotificationClickListener

    func onClick(event: OSNotificationClickEvent) {
        let data = event.notification.additionalData as? [String: Any]
        guard SafetyDaysNotificationService.isSafetyDaysPush(data) else { return }

        let contentId = SafetyDaysNotificationService.contentId(from: data)
        let onesignalId = event.notification.notificationId
        NSLog(
            "[OneSignal] safety_days click contentId=%@",
            contentId ?? "(none)"
        )

        Task { @MainActor in
            SafetyDaysNotificationService.shared.markPushArrived(
                contentId: contentId,
                onesignalId: onesignalId
            )
            PushNavigationStore.shared.openSafetyDays(contentId: contentId)
        }
    }
}
