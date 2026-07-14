//
//  GCAPApp.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

@main
struct GCAPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
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
                        // Show Allow Notifications after splash → home is visible.
                        PushPermissionRequester.requestAfterSplash()
                    }
                    .transition(.opacity)
                    .zIndex(1)
                    .ignoresSafeArea()
                    .task{
                        CalculatorAnalytics.shared.initIfNeeded()
                        await SafetyDaysNotificationService.shared.refresh()

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
