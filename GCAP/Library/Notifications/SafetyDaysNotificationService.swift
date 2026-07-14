//
//  SafetyDaysNotificationService.swift
//  GCAP
//

import Foundation

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
    /// Sticky unread from a push until the user opens Notification.
    private let pushUnreadKey = "safety_days_push_unread"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private init() {
        loadCache()
        refreshUnreadFlag()
    }

    /// Call when a Safety Days push arrives so the menu badge shows immediately.
    func markUnreadFromPush(contentId: String? = nil) {
        UserDefaults.standard.set(true, forKey: pushUnreadKey)
        hasUnreadUpdate = true
        NSLog("[SafetyDaysNotify] Push unread badge set contentId=%@", contentId ?? "(none)")
        Task {
            await refresh(contentId: contentId)
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
        UserDefaults.standard.set(false, forKey: pushUnreadKey)
        UserDefaults.standard.set(id, forKey: seenIdKey)
        UserDefaults.standard.set(version, forKey: seenVersionKey)
        refreshUnreadFlag()
    }

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
        // Different content id counts as unread even if version numbers overlap.
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
}
