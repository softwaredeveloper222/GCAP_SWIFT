//
//  ChartsGraphsView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct ChartsGraphsView: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    @State private var show_image_popup: Bool = false
    
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
    }
    
    //MARK: contentview
    var contentView: some View {
        ZStack{
            HeaderView(headerText: headerText)
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size)
                ScrollView {
                    chartsList
                        .padding()
                        .padding(.bottom, 60)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if show_image_popup == true {
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
            
            await viewModel.GetChartsGraphsData()
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
            
            AsyncImage(url: URL(string: IMAGE_URL + image_url)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                ProgressView()
            }
            
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
    
    private var chartsList: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(stride(from: 0, to: viewModel.chartsGraphsData.count, by: 2)), id: \.self) { index in
                    chartRow(for: index)
                }
            }
            .background(Color.clear)
        }
    }
    
    @ViewBuilder
    private func chartRow(for index: Int) -> some View {
        HStack(spacing: 0) {
            GeometryReader { geometry in
                HStack(spacing: 1) {
                    let itemWidth = geometry.size.width / 2
                    
                    let currentItem = viewModel.chartsGraphsData[index]
                    ChartsListItem(
                        imageUrls: currentItem.image,
                        imageText: currentItem.name,
                        popup_url: currentItem.image,
                        show_popup_image: $show_image_popup,
                        popup_image_url: $image_url
                    )
                    .frame(width: itemWidth, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
                    
                    if index + 1 < viewModel.chartsGraphsData.count {
                        let nextItem = viewModel.chartsGraphsData[index + 1]
                        ChartsListItem(
                            imageUrls: nextItem.image,
                            imageText: nextItem.name,
                            popup_url: nextItem.image,
                            show_popup_image: $show_image_popup,
                            popup_image_url: $image_url
                        )
                        .frame(width: itemWidth, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
                    } else {
                        Spacer()
                            .frame(width: itemWidth, height:UIDevice.current.userInterfaceIdiom == .pad ? 240 :  180)
                    }
                }
            }
            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180)
        }
    }
}


//
#Preview {
    ChartsGraphsView(path : .constant(NavigationPath()), headerText: "ChartsGraphs")
}
