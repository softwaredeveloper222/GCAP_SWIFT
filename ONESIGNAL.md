# OneSignal (iOS)

## Current config

| Item | Value |
|------|--------|
| OneSignal App ID | `3acc100c-877e-49d4-9a51-d65fa4e77c86` (same as Android) |
| Config file | `GCAP/Library/Notifications/OneSignalConfig.swift` |
| Entitlements | `GCAP/GCAP.entitlements` (`aps-environment` = `development`) |

## Behavior

1. **App launch** — `AppDelegate` initializes OneSignal (VERBOSE logs) and registers the Safety Days click listener. No permission prompt yet.
2. **After splash** — `PushPermissionRequester.requestAfterSplash()` shows the Allow Notifications alert, then calls `pushSubscription.optIn()` (same as Android).
3. **Push tap** (`type=safety_days`) — opens Safety Days and fetches `?id=<contentId>` from push `data.contentId` / `data.id`.
4. **Unread badge** — tracks seen by **content id + version** (same as Android).

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
