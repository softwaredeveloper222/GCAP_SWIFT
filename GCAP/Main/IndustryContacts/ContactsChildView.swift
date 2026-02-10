//
//  FormulasView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct ContactsChildView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    
    let industryItem: IndustryContactsData
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var website = ""
    @State private var addressLine = ""
    @State private var aboutText = ""
    @State private var image_url = ""
    
    init(path: Binding<NavigationPath>, industryItemData: IndustryContactsData,  headerText: String) {
        self._path = path
        self.industryItem = industryItemData
        self.headerText = headerText
        loadingManager.show()
    }
    
    //MARK: mainview
    var body: some View {
        ZStack{
            contentView
            
            if loadingManager.isLoading {
                LoadingOverlayView()
            }
        }
        .onAppear {
            phoneNumber = industryItem.phone
            email = industryItem.email
            website = industryItem.website
            addressLine = industryItem.address
            aboutText = industryItem.about
            image_url = industryItem.image
        }
    }
    
    //MARK: contentview
    var contentView: some View {
        ZStack{
            IndustryContactHeaderView(headerText: headerText, logo_image_url: "uploads/16529002012401.jpg")
                VStack{
                    ScrollView{
                        ZStack(alignment: .top) {
                            // Card
                            VStack(alignment: .leading, spacing: 10) {
                                Spacer().frame(height: 40)
                                InfoRow(icon: "user", label: "Contact Person", content: industryItem.contactPerson)
                                
                                ButtonRow(
                                    icon: "phone",
                                    label: "Phone Number",
                                    content: formattedPhone(phoneNumber),
                                    action: { openURL("tel://\(phoneNumber)") }
                                )
                                
                                ButtonRow(
                                    icon: "email",
                                    label: "Email Address",
                                    content: email,
                                    action: { openURL("mailto:\(email)") }
                                )
                                
                                LinkRow(
                                    icon: "website",
                                    label: "Website",
                                    urlString: website
                                )
                                
                                ButtonRow(
                                    icon: "location",
                                    label: "Address",
                                    content: addressLine,
                                    action: {
                                        let q = addressLine.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                                        openURL("http://maps.apple.com/?q=\(q)")
                                    }
                                )
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    RowHeader(icon: "message", label: "About")
                                    Text(aboutText)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.primary)
                                        .padding(.leading, 28)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.background)
                                    .shadow(color: .gray/*.opacity(0.08)*/, radius: 12, x: 4, y: 6)
                            )
                            .padding(.bottom, 24)
                            .padding(.top, 60)
                            
                            VStack{
                                AsyncImage(url: URL(string: IMAGE_URL + image_url)) {image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .border(Color.gray, width: 1)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .padding(10)
                    }
                }
                .padding(.top, 130)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                
                Button(action: {dismiss()}) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                    }
                    .foregroundColor(Color.white)
                }
            }
            
        }
        .task{
            try? await Task.sleep(for: .seconds(0.3))
            withAnimation(.easeInOut(duration: 0.3)) {
                loadingManager.hide()
            }
        }
    }
    
    private func formattedPhone(_ raw: String) -> String {
            // 866.866.8730 formatting
            let digits = raw.filter(\.isNumber)
            guard digits.count == 10 else { return raw }
            let a = digits.prefix(3)
            let b = digits.dropFirst(3).prefix(3)
            let c = digits.suffix(4)
            return "\(a).\(b).\(c)"
        }

        private func openURL(_ urlString: String) {
            guard let url = URL(string: urlString) else { return }
            #if os(iOS)
            UIApplication.shared.open(url)
            #endif
        }
}

private struct RowHeader: View {
    let icon: String
    let label: String
    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
                .resizable()
                .frame(width: 15, height: 16)
                .foregroundStyle(.secondary)
            Text(label)
                .font(.callout)
                .foregroundStyle(.primary)
            Spacer()
        }
        .accessibilityElement(children: .combine)
    }
}

private struct InfoRow: View {
    let icon: String
    let label: String
    let content: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            RowHeader(icon: icon, label: label)
            Text(content)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(.leading, 28)
//                .accessibilityLabel("\(label): \(content)")
        }
    }
}

private struct ButtonRow: View {
    let icon: String
    let label: String
    let content: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                RowHeader(icon: icon, label: label)
                Text(content)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 28)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct LinkRow: View {
    let icon: String
    let label: String
    let urlString: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            RowHeader(icon: icon, label: "Website")
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    Text(urlString)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .padding(.leading, 28)
//                        .font(.body)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                }
                .accessibilityLabel("\(label): \(urlString)")
            } else {
                Text(urlString)
                    .font(.body)
            }
        }
    }
}

#Preview {
//    ContactsChildView(path : .constant(NavigationPath()), headerText: "ContactsChild")
}
