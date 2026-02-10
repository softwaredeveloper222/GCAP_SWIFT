//
//  IndustryContactHeaderView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct IndustryContactHeaderView: View {
    let headerText: String
    let logo_image_url: String
    
    @State private var logo_height_pos: Int = 200
    @State private var logo_max_height: Int = 140
    @State private var padding_bottom_size: Double = 25
    var body: some View {
        GeometryReader{ geo in
            VStack {
                Spacer().frame(height: 50)
                Text(headerText).font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 22 : 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.bottom, 25)
                    .padding(.top, 20)
                
                Image("background")
                    .resizable()
                    .overlay(Color.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#2D2F93"))
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    IndustryContactHeaderView(headerText: "header", logo_image_url: "uploads/16529002012401.jpg")
}
