//
//  LoadingOverlayView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
                .padding(16)
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
        }
    }
}
#Preview {
    ZStack {
        LoadingOverlayView()
    }
}
