//
//  SafetyDaysView.swift
//  GCAP
//

import SwiftUI

/// Typography matched to gcaptraining.com/safety-days (Education Soul / Roboto).
private enum SafetyDaysStyle {
    static let heading = Color(hex: "#00387D")
    static let body = Color(hex: "#727272")
    static let pageBg = Color(hex: "#FBFBFB")
}

struct SafetyDaysView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    /// From OneSignal push `data.contentId` — fetch that CMS page (`?id=`).
    var contentId: String? = nil

    @ObservedObject private var service = SafetyDaysNotificationService.shared
    @State private var webDestination: SafetyDaysWebDestination?

    var body: some View {
        ZStack {
            HeaderView(headerText: headerText, showLogo: false)
            VStack(spacing: 0) {
                Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 129 : 124)

                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            if let content = service.payload?.content {
                                SafetyDaysContentBody(
                                    content: content,
                                    onOpenWeb: { title, url in
                                        webDestination = SafetyDaysWebDestination(
                                            title: title,
                                            urlString: url
                                        )
                                    }
                                )

                                if let version = service.payload?.version {
                                    Text(
                                        service.lastFetchFromNetwork && service.lastError == nil
                                            ? "Updated · version \(version)"
                                            : "Showing saved content · version \(version)"
                                    )
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#888888"))
                                    .padding(.top, 8)
                                }
                            } else if service.isLoading {
                                ProgressView("Loading Safety Days…")
                                    .frame(maxWidth: .infinity, minHeight: 200)
                            } else {
                                Text(service.lastError ?? "Unable to load Safety Days.")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "#888888"))
                                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 36)
                    }

                    if service.isLoading && service.payload != nil {
                        ProgressView()
                            .tint(SafetyDaysStyle.heading)
                            .padding(.top, 8)
                    }
                }
                .background(SafetyDaysStyle.pageBg)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                    }
                    .foregroundColor(Color.white)
                }
            }
        }
        .navigationDestination(item: $webDestination) { destination in
            SafetyDaysWebView(title: destination.title, urlString: destination.urlString)
        }
        .task {
            await service.refresh(contentId: contentId)
            service.markSeen()
        }
    }
}

private struct SafetyDaysContentBody: View {
    let content: SafetyDaysContent
    let onOpenWeb: (String, String) -> Void

    private var benefitBullets: [String] {
        content.bullets.filter { !$0.localizedCaseInsensitiveContains("sponsorship") }
    }

    private var dateDetailParagraphs: [String] {
        var items: [String] = []
        if let location = content.location, !location.isEmpty {
            items.append("@  \(location)")
        }
        if let price = content.priceAttendee, !price.isEmpty {
            items.append(price)
        }
        if let price = content.priceExhibitor, !price.isEmpty {
            items.append(price)
        }
        items.append(
            contentsOf: content.bullets.filter {
                $0.localizedCaseInsensitiveContains("sponsorship")
            }
        )
        return items
    }

    var body: some View {
        Group {
            Text(content.title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(SafetyDaysStyle.heading)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineSpacing(4)

            if let hero = content.heroImageUrl,
               let heroUrl = URL(string: hero) {
                AsyncImage(url: heroUrl) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Color.gray.opacity(0.2)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
            }

            if let subtitle = content.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(SafetyDaysStyle.heading)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineSpacing(3)
            }

            if let eventName = content.eventName, !eventName.isEmpty {
                Text(eventName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(SafetyDaysStyle.heading)
                    .padding(.top, 4)
            }

            if !benefitBullets.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(benefitBullets, id: \.self) { bullet in
                        Text(bullet)
                            .font(.system(size: 14))
                            .foregroundColor(SafetyDaysStyle.body)
                            .lineSpacing(4)
                    }
                }
            }

            if let dateLabel = content.dateLabel, !dateLabel.isEmpty {
                Text("Date: \(dateLabel)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(SafetyDaysStyle.heading)
                    .padding(.top, 4)
            }

            if !dateDetailParagraphs.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(dateDetailParagraphs, id: \.self) { line in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.system(size: 14))
                                .foregroundColor(SafetyDaysStyle.body)
                            Text(line)
                                .font(.system(size: 14))
                                .foregroundColor(SafetyDaysStyle.body)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.leading, 4)
            }

            if let registerUrl = content.registerUrl, !registerUrl.isEmpty {
                Button {
                    onOpenWeb("Click Here to Register", registerUrl)
                } label: {
                    Text("Click Here to Register")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(SafetyDaysStyle.heading)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
            }

            if let hotelsUrl = content.hotelsUrl, !hotelsUrl.isEmpty {
                Button {
                    onOpenWeb("Recommended Hotels", hotelsUrl)
                } label: {
                    Text("Link to Recommended Hotels")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(SafetyDaysStyle.heading)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }

            if let body = content.bodyHtml, !body.isEmpty {
                Text(body)
                    .font(.system(size: 14))
                    .foregroundColor(SafetyDaysStyle.body)
                    .lineSpacing(4)
                    .padding(.top, 4)
            }

            if !content.galleryImages.isEmpty {
                VStack(spacing: 12) {
                    ForEach(content.galleryImages) { image in
                        if let url = URL(string: image.url) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let img):
                                    img
                                        .resizable()
                                        .scaledToFit()
                                case .failure:
                                    Color.gray.opacity(0.15)
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .accessibilityLabel(image.alt ?? "Safety Days photo")
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    SafetyDaysView(path: .constant(NavigationPath()), headerText: "Safety Days")
}
