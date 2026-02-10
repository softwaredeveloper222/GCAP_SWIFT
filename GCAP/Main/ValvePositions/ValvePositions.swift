//
//  ValvePositions.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct ValvePositions: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    @State private var show_popup_image = false
    @State private var popup_image_url = ""
    
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
        }
    }
    
    //MARK: contentview
    var contentView: some View {
        ZStack{
            HeaderView(headerText: headerText)
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size)
                
                ScrollView{
                    VStack(spacing: 20){
                        ForEach(viewModel.valvePositionsData) { item in
                            ImageListItem(imageUrls: item.image, imageText: item.name,  popup_url: item.list.first?.image ?? "", show_popup_image: $show_popup_image, popup_image_url: $popup_image_url)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()
            }
            
            if show_popup_image == true {
                ImagePopupView
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                
                Button(action: goBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                    }
                    .foregroundColor(Color.white)
                }
            }
            
        }
        .task{
            await viewModel.GetValvePositionsData()
            
            loadingManager.hide()
        }
    }
    
    func goBack(){
        if show_popup_image == false {
            dismiss()
        }
    }
    
    var ImagePopupView: some View{
        
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    show_popup_image = false
                }
            
            AsyncImage(url: URL(string: IMAGE_URL + popup_image_url))
            { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 120 : 0)
            
            
            Button(action: {show_popup_image = false}){
                Text("Close")
                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 30 : 15))
                    .foregroundStyle(.white)
                    .padding(.top, 80)
                    .padding(.trailing, 20)
            }
        }
        .opacity(0.95)
        .padding(.top, 20)
    }
}

#Preview {
    ValvePositions(path : .constant(NavigationPath()), headerText: "ValvePositions")
}
