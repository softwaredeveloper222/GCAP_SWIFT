//
//  PushNavigationStore.swift
//  GCAP
//

import Foundation
import Combine

@MainActor
final class PushNavigationStore: ObservableObject {
    static let shared = PushNavigationStore()

    @Published var pendingRoute: AppRoute?
    /// CMS content id from OneSignal `data.contentId` / `data.id` (fetch that page).
    @Published var pendingContentId: String?

    private init() {}

    func openSafetyDays(contentId: String? = nil) {
        let trimmed = contentId?.trimmingCharacters(in: .whitespacesAndNewlines)
        pendingContentId = (trimmed?.isEmpty == false) ? trimmed : nil
        pendingRoute = .safety_days
    }

    func consumePendingRoute() -> (route: AppRoute, contentId: String?)? {
        guard let route = pendingRoute else { return nil }
        let contentId = pendingContentId
        pendingRoute = nil
        pendingContentId = nil
        return (route, contentId)
    }
}
