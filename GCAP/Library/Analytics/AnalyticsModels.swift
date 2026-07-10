//
//  AnalyticsModels.swift
//  GCAP
//

import Foundation

struct AnalyticsEventPayload: Codable {
    let event: String
    let calculatorId: String?
    let sessionId: String
    let deviceId: String
    let appVersion: String?
    let platform: String
    let deviceManufacturer: String?
    let deviceModel: String?
    let deviceBrand: String?
    let osVersion: String?
    let durationMs: Int64?
    let success: Bool?
}

struct AnalyticsIngestPayload: Codable {
    let events: [AnalyticsEventPayload]
}

struct AnalyticsIngestResponse: Codable {
    let accepted: Int
    let message: String
}
