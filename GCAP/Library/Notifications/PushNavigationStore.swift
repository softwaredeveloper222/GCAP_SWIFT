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

    private init() {}

    func openSafetyDays() {
        pendingRoute = .safety_days
    }

    func consumePendingRoute() -> AppRoute? {
        let route = pendingRoute
        pendingRoute = nil
        return route
    }
}
