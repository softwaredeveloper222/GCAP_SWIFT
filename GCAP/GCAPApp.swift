//
//  GCAPApp.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

@main
struct GCAPApp: App {
    @State private var showSplash = true
    var body: some Scene {
        WindowGroup {
            ZStack{
                ContentView()
                
                if showSplash {
                    SplashView{
                        withAnimation(.easeOut(duration: 0.45)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                    .ignoresSafeArea()
                    .task{
                        try? await Task.sleep(nanoseconds: 100_000_000)
                        
                        await ExcelDataModel.shared.loadExcel_PSIG()
                        await ExcelDataModel.shared.loadExcel_PSIA()
                        await ExcelDataModel.shared.loadExcel_PSIF()
                        await ExcelDataModel.shared.loadExcel_Superheat()
                    }
                }
            }
           
        }
        
    }
}
