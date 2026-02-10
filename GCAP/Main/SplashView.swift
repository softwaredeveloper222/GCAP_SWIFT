//
//  SplashView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void

    @State private var isAnimatingLogo = false
    @State private var rotateRing = false
    @State private var scaleUp = false
    @State private var showShadow = false

    private let totalDuration: TimeInterval = 2.4
    
    @State private var rotation: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("splash")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .clipped()
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 6)
                            .opacity(0.20)
                            .frame(width: 48, height: 48)

                        Circle()
                            .trim(from: 0.0, to: 0.65)
                            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 48, height: 48)
                            .rotationEffect(.degrees(rotateRing ? 360 : 0))
                            .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: rotateRing)
                        
                        Spacer().frame(height: geo.size.height/3)
                    }
                    .foregroundColor(.white)
                    .padding(.top, 6)
                    .opacity(isAnimatingLogo ? 1 : 0)
                }
                .padding(.horizontal, 32)
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    isAnimatingLogo = true
                    showShadow = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    scaleUp = true
                }

                rotateRing = true

                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                        scaleUp = false
                        isAnimatingLogo = false
                        showShadow = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        onFinished()
                    }
                }
            }
        }
    }
}

extension Color {
    init(_ assetName: String, default fallback: Color) {
        if let _ = UIColor(named: assetName) {
            self = Color(assetName)
        } else {
            self = fallback
        }
    }
}
//#Preview {
//    SplashView(onFinished())
//}
