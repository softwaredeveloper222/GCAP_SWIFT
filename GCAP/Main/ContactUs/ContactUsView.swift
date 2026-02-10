//
//  ContactUsView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct ContactUsView: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    
    @State private var show_notification = false
    @State private var message_text = ""
    
    init(path: Binding<NavigationPath>, headerText: String) {
        self._path = path
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
            
            if show_notification {
                NotificationView(message: message_text)
                    .task{
                        try? await Task.sleep(for: .seconds(4))
                        withAnimation(.easeIn(duration: 0.3)) {
                            show_notification = false
                        }
                    }
            }
        }
    }
    
    //MARK: contentview
    var contentView: some View {
        ZStack(){
            HeaderView(headerText: headerText)
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size + 20)
                ScrollView {
                    VStack(spacing: 24) {
                        // --- Get in touch form ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Get in touch")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            IconTextField(text: $name, icon: "user", placeholder: "Name")
                                .background(Color(hex: "#F9F9F9"))
                                .shadow(radius: 0.5)
                            
                            IconTextField(text: $email, icon: "email", placeholder: "Email ID")
                                .background(Color(hex: "#F9F9F9"))
                                .shadow(radius: 0.5)
                            
                            CustomTextEditor(icon: "email", placeholder: "Message", text: $message)
                                .shadow(radius: 0.5)
                                
                            HStack(alignment: .center, spacing: 0){
                                Spacer()
                                Button(action: {
                                    onClickedSendBtn()
                                }) {
                                    Text("Send")
                                        .padding(.leading, 45)
                                        .padding(.trailing, 45)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(hex: "#2C2C87"))
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                        .shadow(radius: 2, y: 1)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(width: 160, height: 50, alignment: .center)
                                .padding(.bottom, 20)
                                
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 6, y: 2)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Contact Details")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.bottom, 4)
                                .padding(.top, 4)
                                
                            ContactRow(icon: "contact_phone", text: viewModel.contactInfoData?.phone ?? "")
                            ContactRow(icon: "contact_email", text: viewModel.contactInfoData?.email ?? "")
                            ContactRow(icon: "contact_address", text: viewModel.contactInfoData?.address ?? "")
                            ContactRow(icon: "contact_website", text: viewModel.contactInfoData?.website ?? "")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#3F42C0"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                    }
                    .foregroundColor(Color.white)
                }
            }
            
        }
        .task{
            await viewModel.GetContactUsData()
            
            loadingManager.hide()
        }
    }
    
    private func onClickedSendBtn(){
        if name.isEmpty {
            message_text = "Please enter your name"
            show_notification = true
        }
        
        if email.isEmpty {
            message_text = "Please enter your email"
            show_notification = true
        }
        
        if message.isEmpty {
            message_text = "Please enter your message"
            show_notification = true
        }
        loadingManager.show()
        Task{
            let flag = await viewModel.sendContactData(name: name, mail: email, message: message)
            
            if flag != true{
                message_text = "Please check your connection."
                show_notification = true
                
                loadingManager.hide()
            }else{
                message_text = "Your message has been sent to us."
                show_notification = true
                loadingManager.hide()
            }
            
            
        }
    }
}

struct ContactRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(icon)
                .resizable()
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
            
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .fontWeight(.semibold)
        }
        .lineSpacing(20)
    }
}

#Preview {
    ContactUsView(path : .constant(NavigationPath()), headerText: "ContactUs")
}
