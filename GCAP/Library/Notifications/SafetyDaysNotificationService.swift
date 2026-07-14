//
//  SafetyDaysNotificationService.swift
//  GCAP
//

import Foundation
import UserNotifications

@MainActor
final class SafetyDaysNotificationService: ObservableObject {
    static let shared = SafetyDaysNotificationService()

    @Published private(set) var payload: SafetyDaysPublicResponse?
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: String?
    @Published private(set) var hasUnreadUpdate = false
    @Published private(set) var lastFetchFromNetwork = false

    private let cacheKey = "safety_days_cached_payload"
    private let seenVersionKey = "safety_days_seen_version"
    private let seenIdKey = "safety_days_seen_id"
    private let pushUnreadKey = "safety_days_push_unread"
    private let processedPushIdsKey = "safety_days_processed_push_ids"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private init() {
        loadCache()
        refreshUnreadFlag()
    }

    /// Re-read unread state from disk (e.g. home appear). Does not hit the network.
    func reloadUnreadFlag() {
        refreshUnreadFlag()
    }

    /// Call when a safety_days push arrives (foreground banner, tap, or delivered tray sync).
    func markPushArrived(contentId: String? = nil, onesignalId: String? = nil) {
        if let onesignalId, !onesignalId.isEmpty {
            var processed = Set(UserDefaults.standard.stringArray(forKey: processedPushIdsKey) ?? [])
            processed.insert(onesignalId)
            UserDefaults.standard.set(Array(processed), forKey: processedPushIdsKey)
        }
        UserDefaults.standard.set(true, forKey: pushUnreadKey)
        refreshUnreadFlag()
        NSLog("[SafetyDaysNotify] Push unread flagged contentId=%@", contentId ?? "(none)")
        Task {
            await refresh(contentId: contentId)
        }
    }

    /// Mirrors Android Notification Service Extension: if a new Safety Days push is sitting
    /// in Notification Center, show the home "New" badge without opening it.
    /// Already-processed notification ids are skipped so an old tray item does not re-badge
    /// after the user has opened Notification.
    func syncUnreadFromDeliveredNotifications() {
        let processedKey = processedPushIdsKey
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            var processed = Set(UserDefaults.standard.stringArray(forKey: processedKey) ?? [])
            var contentIdToFlag: String?
            var didDiscoverNew = false

            for notification in notifications {
                let userInfo = notification.request.content.userInfo
                let data = Self.additionalData(from: userInfo)
                guard Self.isSafetyDaysPush(data) else { continue }

                let pushId = Self.onesignalNotificationId(from: userInfo)
                    ?? notification.request.identifier
                if processed.contains(pushId) { continue }

                processed.insert(pushId)
                didDiscoverNew = true
                if contentIdToFlag == nil {
                    contentIdToFlag = Self.contentId(from: data)
                }
            }

            guard didDiscoverNew else { return }

            UserDefaults.standard.set(Array(processed), forKey: processedKey)
            Task { @MainActor in
                SafetyDaysNotificationService.shared.markPushArrived(contentId: contentIdToFlag)
            }
        }
    }

    /// - Parameter contentId: When set (push tap), fetch that CMS page via `?id=`.
    func refresh(contentId: String? = nil) async {
        guard AnalyticsConfig.enabled else { return }

        var components = URLComponents(
            string: AnalyticsConfig.baseURL + "api/notifications/safety-days/public"
        )
        let trimmedId = contentId?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if let trimmedId, !trimmedId.isEmpty {
            components?.queryItems = [URLQueryItem(name: "id", value: trimmedId)]
        }

        guard let url = components?.url else {
            lastError = "Invalid notification URL"
            return
        }

        isLoading = true
        defer { isLoading = false }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("Bearer \(AnalyticsConfig.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard (200...299).contains(status) else {
                lastError = "Server returned \(status)"
                lastFetchFromNetwork = false
                NSLog("[SafetyDaysNotify] Fetch failed: \(status)")
                return
            }

            let decoded = try decoder.decode(SafetyDaysPublicResponse.self, from: data)
            payload = decoded
            saveCache(decoded)
            refreshUnreadFlag()
            lastError = nil
            lastFetchFromNetwork = true
            NSLog(
                "[SafetyDaysNotify] Loaded id=%@ version=%d images=%d",
                decoded.id,
                decoded.version,
                decoded.content.galleryImages.count
            )
        } catch {
            lastError = error.localizedDescription
            lastFetchFromNetwork = false
            NSLog("[SafetyDaysNotify] Network error: \(error.localizedDescription)")
        }
    }

    func markSeen() {
        guard let payload else { return }
        markSeen(id: payload.id, version: payload.version)
    }

    func markSeen(id: String, version: Int) {
        UserDefaults.standard.set(id, forKey: seenIdKey)
        UserDefaults.standard.set(version, forKey: seenVersionKey)
        UserDefaults.standard.set(false, forKey: pushUnreadKey)
        refreshUnreadFlag()
    }

    // MARK: - Private

    private func refreshUnreadFlag() {
        if UserDefaults.standard.bool(forKey: pushUnreadKey) {
            hasUnreadUpdate = true
            return
        }
        guard let payload else {
            hasUnreadUpdate = false
            return
        }
        let seenId = UserDefaults.standard.string(forKey: seenIdKey)
        let seenVersion = UserDefaults.standard.integer(forKey: seenVersionKey)
        if let seenId, seenId != payload.id {
            hasUnreadUpdate = true
            return
        }
        hasUnreadUpdate = payload.version > seenVersion
    }

    private func loadCache() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return }
        do {
            payload = try decoder.decode(SafetyDaysPublicResponse.self, from: data)
        } catch {
            UserDefaults.standard.removeObject(forKey: cacheKey)
        }
    }

    private func saveCache(_ payload: SafetyDaysPublicResponse) {
        do {
            let data = try encoder.encode(payload)
            UserDefaults.standard.set(data, forKey: cacheKey)
        } catch {
            NSLog("[SafetyDaysNotify] Failed to cache payload: \(error)")
        }
    }

    /// Returns OneSignal notification UUID from APNs `custom.i` if present.
    static func onesignalNotificationId(from userInfo: [AnyHashable: Any]) -> String? {
        if let custom = userInfo["custom"] as? [String: Any],
           let id = custom["i"] as? String,
           !id.isEmpty
        {
            return id
        }
        if let customString = userInfo["custom"] as? String,
           let customData = customString.data(using: .utf8),
           let custom = try? JSONSerialization.jsonObject(with: customData) as? [String: Any],
           let id = custom["i"] as? String,
           !id.isEmpty
        {
            return id
        }
        return nil
    }

    static func isSafetyDaysPush(_ data: [String: Any]?) -> Bool {
        guard let type = data?["type"] as? String else { return false }
        return type == "safety_days"
    }

    static func contentId(from data: [String: Any]?) -> String? {
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

    /// OneSignal packs additional data under `custom` → `a` (dict or JSON string).
    static func additionalData(from userInfo: [AnyHashable: Any]) -> [String: Any]? {
        if let custom = userInfo["custom"] as? [String: Any] {
            if let additional = custom["a"] as? [String: Any] {
                return additional
            }
        }
        if let customString = userInfo["custom"] as? String,
           let customData = customString.data(using: .utf8),
           let custom = try? JSONSerialization.jsonObject(with: customData) as? [String: Any]
        {
            if let additional = custom["a"] as? [String: Any] {
                return additional
            }
            if let additionalString = custom["a"] as? String,
               let additionalData = additionalString.data(using: .utf8),
               let additional = try? JSONSerialization.jsonObject(with: additionalData) as? [String: Any]
            {
                return additional
            }
        }
        // Fallbacks used by some payload shapes / click payloads.
        if let type = userInfo["type"] as? String {
            return userInfo.reduce(into: [String: Any]()) { result, pair in
                if let key = pair.key as? String {
                    result[key] = pair.value
                }
            }.merging(["type": type]) { _, new in new }
        }
        return nil
    }
}
