//
//  SafetyDaysModels.swift
//  GCAP
//

import Foundation

struct SafetyDaysPublicResponse: Codable {
    let id: String
    let version: Int
    let publishedAt: String?
    let updatedAt: String?
    let content: SafetyDaysContent
}

struct SafetyDaysContent: Codable {
    let title: String
    let subtitle: String?
    let eventName: String?
    let dateLabel: String?
    let location: String?
    let priceAttendee: String?
    let priceExhibitor: String?
    let bullets: [String]
    let registerUrl: String?
    let hotelsUrl: String?
    let bodyHtml: String?
    let heroImageUrl: String?
    let images: [SafetyDaysImage]?

    var galleryImages: [SafetyDaysImage] {
        (images ?? []).filter { !$0.url.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
}

struct SafetyDaysImage: Codable, Identifiable {
    var id: String { url }
    let url: String
    let alt: String?
}
