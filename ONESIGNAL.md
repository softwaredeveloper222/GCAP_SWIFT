# OneSignal (iOS)

## Current config

| Item | Value |
|------|--------|
| OneSignal App ID | `3acc100c-877e-49d4-9a51-d65fa4e77c86` (same as Android) |
| Config file | `GCAP/Library/Notifications/OneSignalConfig.swift` |
| Entitlements | `GCAP/GCAP.entitlements` (`aps-environment` = `development`) |

## Behavior

1. **App launch** — `AppDelegate` initializes OneSignal (VERBOSE logs) and registers the Safety Days click listener. No permission prompt yet.
2. **After splash** — `PushPermissionRequester.requestAfterSplash()` shows the Allow Notifications alert (~400ms after home appears).

## Xcode checklist

1. OneSignal dashboard → enable **Apple iOS** and upload your APNs `.p8` key.
2. Package `https://github.com/OneSignal/OneSignal-XCFramework` (product: **OneSignalFramework**) is already linked.
3. Signing & Capabilities → **Push Notifications** (via entitlements).
4. For App Store / TestFlight, set `aps-environment` to `production` in entitlements.
5. Test on a **physical device** (Simulator cannot register for real push).
