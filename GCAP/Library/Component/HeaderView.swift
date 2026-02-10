//
//  HeaderView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI


struct HeaderView: View {
    let headerText: String
    
    @State private var logo_height_pos: Int = 130
    @State private var logo_max_height: Int = 140
    @State private var padding_bottom_size: Double = 25
    var body: some View {
        GeometryReader{ geo in
            VStack {
                Spacer().frame(height: 50)
                Text(headerText).font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 22 : 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 35 : 25)
                    .padding(.top, 20)
                
                Image("background")
                    .resizable()
                    .overlay(Color.white.opacity(0.9))
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#2D2F93"))
            
            ZStack{
                Image("logo")
                    .resizable()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 150 : 110, height: UIDevice.current.userInterfaceIdiom == .pad ? 150 : 110)
                    .clipShape(Circle())
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: BASE_URL)!)
                    }
            }
            .position(x: geo.size.width / 2, y: CGFloat(logo_height_pos))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear{
            if headerText == " " {
                logo_height_pos = UIDevice.current.userInterfaceIdiom == .pad ? 140 : 120
                logo_max_height = UIDevice.current.userInterfaceIdiom == .pad ? 175 :140
                padding_bottom_size = 25
            }
            else{
                logo_height_pos = UIDevice.current.userInterfaceIdiom == .pad ? 170 : 150
                logo_max_height = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 165
                padding_bottom_size = 40
            }
        }
    }
}

#Preview {
    HeaderView(headerText: "header")
}
