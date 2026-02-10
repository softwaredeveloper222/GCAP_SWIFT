//
//  ChartsGraphsView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI
import AVKit

struct AnimationsView: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    @State private var show_image_popup: Bool = false
    
    @State private var card_image_url_1 = ""
    @State private var card_image_url_2 = ""
    @State private var card_image_text_1 = ""
    @State private var card_image_text_2 = ""
    @State private var image_url = ""
    
    
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
        .fullScreenCover(isPresented: $show_image_popup) {
            FullscreenVideoPlayer(videoURL: URL(string: IMAGE_URL + video_url)!)
        }
    }
    
    //MARK: contentview
    var contentView: some View {
        ZStack{
            HeaderView(headerText: headerText)
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size)
                ScrollView {
                    animationsList
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // hide default arrow
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss() // 👈 go back
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
            await viewModel.GetAnimationsData()
            
            loadingManager.hide()
        }
    }
    
    var ImagePopupView: some View{
        
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    show_image_popup = false
                }
            
            Image(image_url)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button(action: {show_image_popup = false}){
                Text("Close")
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
                    .padding(.top, 80)
                    .padding(.trailing, 20)
            }
        }
        .opacity(0.95)
        .padding(.top, 20)
    }
    
    private var animationsList: some View {
        VStack(spacing: 10) {
            VStack(alignment: .center, spacing: 10) {
                ForEach(Array(stride(from: 0, to: viewModel.animation.count, by: 2)), id: \.self) { index in
                    animationRow(for: index)
                }
            }
            .background(Color.clear)
        }
    }
    
    @ViewBuilder
    private func animationRow(for index: Int) -> some View {
        HStack(spacing: 1) {
            GeometryReader { geometry in
                let itemWidth = geometry.size.width / 2 - 1
                
                HStack(spacing: 1) {
                    if index < viewModel.animation.count {
                        let currentItem = viewModel.animation[index]
                        
                        AnimationsCardItem(
                            imageUrls: currentItem.image ?? "",
                            imageText: currentItem.name ?? "",
                            popup_url: currentItem.image ?? "",
                            show_popup_image: $show_image_popup,
                            popup_image_url: $image_url
                        )
                        .frame(width: itemWidth, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
                    }
                    
                    if index + 1 < viewModel.animation.count {
                        let nextItem = viewModel.animation[index + 1]
                        
                        AnimationsCardItem(
                            imageUrls: nextItem.image ?? "",
                            imageText: nextItem.name ?? "",
                            popup_url: nextItem.image ?? "",
                            show_popup_image: $show_image_popup,
                            popup_image_url: $image_url
                        )
                        .frame(width: itemWidth, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
                    } else {
                        Spacer()
                            .frame(width: itemWidth, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
                    }
                }
            }
            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
        }
        .padding(.bottom, 6)
    }
}


//
#Preview {
    AnimationsView(path : .constant(NavigationPath()), headerText: "Animations")
}
