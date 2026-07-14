# OneSignal (iOS)

## Current config

| Item | Value |
|------|--------|
| OneSignal App ID | `3acc100c-877e-49d4-9a51-d65fa4e77c86` (same as Android) |
| Config file | `GCAP/Library/Notifications/OneSignalConfig.swift` |
| Entitlements | `GCAP/GCAP.entitlements` (`aps-environment` = `development`) |

## Behavior

1. **App launch** — `AppDelegate` initializes OneSignal (VERBOSE logs), foreground lifecycle + click listeners. No permission prompt yet.
2. **After splash** — `PushPermissionRequester.requestAfterSplash()` shows Allow Notifications, then `pushSubscription.optIn()`. Splash may prefetch Safety Days CMS once.
3. **Push receive (foreground)** — `onWillDisplay` flags unread + shows system banner (`display()`). Home **New** badge appears immediately.
4. **Push receive (background / tray)** — On become-active / home appear, delivered notifications are scanned; a `type=safety_days` push flags unread (parity with Android NSE).
5. **Push tap** — opens Safety Days and fetches `?id=<contentId>` from `data.contentId` / `data.id`.
6. **Unread badge** — `push_unread` **or** unseen CMS `id`/`version`. Cleared when Safety Days is opened (`markSeen`).
7. **Main menu** — no pull-to-refresh / no network refresh (badge only).

## CMS push payload

```json
{
  "type": "safety_days",
  "version": "12",
  "contentId": "<page-id>",
  "id": "<page-id>"
}
```

## Xcode checklist

1. OneSignal dashboard → enable **Apple iOS** and upload your APNs `.p8` Auth Key (Settings → Platforms → Apple iOS).
2. Package `https://github.com/OneSignal/OneSignal-XCFramework` (product: **OneSignalFramework**) is already linked.
3. Signing & Capabilities → **Push Notifications** (via entitlements).
4. For App Store / TestFlight, set `aps-environment` to `production` in entitlements.
5. Test on a **physical device** (Simulator cannot register for real push).
6. After allowing notifications, confirm Audience → Subscriptions shows Channel=**Push**, Platform=**iOS**, Status=**Subscribed**.
