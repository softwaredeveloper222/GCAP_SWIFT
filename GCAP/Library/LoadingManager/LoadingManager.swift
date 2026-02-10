//
//  LoadingManager.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import Foundation
import SwiftUI
import Combine

class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    
    @Published var isLoading: Bool = false
    
    private init() {}
    
    func show() {
        DispatchQueue.main.async {
            withAnimation {
                
                self.isLoading = true
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            withAnimation {
                self.isLoading = false
            }
        }
    }
}
