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

    enum CodingKeys: String, CodingKey {
        case event, calculatorId, sessionId, deviceId, appVersion, platform
        case deviceManufacturer, deviceModel, deviceBrand, osVersion
        case durationMs, success
    }

    /// Match Android/Gson: omit null optional fields (Zod `.optional()` rejects JSON null).
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(event, forKey: .event)
        try container.encodeIfPresent(calculatorId, forKey: .calculatorId)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(deviceId, forKey: .deviceId)
        try container.encodeIfPresent(appVersion, forKey: .appVersion)
        try container.encode(platform, forKey: .platform)
        try container.encodeIfPresent(deviceManufacturer, forKey: .deviceManufacturer)
        try container.encodeIfPresent(deviceModel, forKey: .deviceModel)
        try container.encodeIfPresent(deviceBrand, forKey: .deviceBrand)
        try container.encodeIfPresent(osVersion, forKey: .osVersion)
        try container.encodeIfPresent(durationMs, forKey: .durationMs)
        try container.encodeIfPresent(success, forKey: .success)
    }
}

struct AnalyticsIngestPayload: Codable {
    let events: [AnalyticsEventPayload]
}

struct AnalyticsIngestResponse: Codable {
    let accepted: Int
    let message: String
}
