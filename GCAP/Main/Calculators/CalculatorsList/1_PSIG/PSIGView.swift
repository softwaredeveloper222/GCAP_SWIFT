//
//  PSIGView.swift
//  GCAP
//
//  Created by admin on 11/6/25.
//

import SwiftUI
import CoreXLSX

struct PSIGView: View {
    @State private var psig = ""
    @State private var psia = ""
    @State private var cvLiquid = ""
    @State private var cvVapor = ""
    @State private var densityLiquid = ""
    @State private var densityVapor = ""
    @State private var temperature = ""
    
    @State private var rows: [PSIGExcelRow] = []
    @State private var result: String = ""
    
    @State private var show_notification = false
    @State private var check_value = 0
    
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    
    var body: some View {
        ZStack{
            contentView
            
            if loadingManager.isLoading {
                LoadingOverlayView()
            }
            
            if show_notification {
                NotificationView(message: "PSIG value must be in -20.4 to 293.1")
                    .task{
                        try? await Task.sleep(for: .seconds(4))
                        withAnimation(.easeIn(duration: 0.3)) {
                            show_notification = false
                        }
                    }
            }
        }
    }
    
    var contentView: some View{
        ZStack {
            HeaderView(headerText: headerText)
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size + 20)
                ScrollView {                // MARK: Form Card
                    VStack(alignment: .leading, spacing : 16){
                        Text("Get From PSIG")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // PSIG row
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("PSIG").font(.system(size: 12, weight: .semibold))
                                    Spacer()
                                    Text("(enter\"hg as minus, i.e.14\"hg = -14)")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                                
                                DualAlignedTextField(checkValue: $check_value, text: $psig, placeholder: "(20.4\"hg to 293.1psig)")
                                    .padding(10)
                                    .background(Color(hex: "#F9F9F9"))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                    )
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .multilineTextAlignment(.trailing)
                                    .font(.system(size: 10))
                            }
                            
                            // PSIA + CV Liquid
                            HStack(spacing: 12) {
                                inputColumn(title: "\n PSIA", value: $psia).font(.system(size: 12, weight: .semibold))
                                inputColumn(title: "Specific Volume (CV Liquid)", subtitle: "\n cu.ft./lbs.", value: $cvLiquid).font(.system(size: 12, weight: .semibold))
                            }
                            
                            // CV Vapor + Density Liquid
                            HStack(spacing: 12) {
                                inputColumn(title: "Specific Volume (CV) Vapor", subtitle: "\n cu.ft./lbs.", value: $cvVapor).font(.system(size: 12, weight: .semibold))
                                inputColumn(title: "\n Density Liquid", subtitle: "\n cu.ft./lbs.", value: $densityLiquid).font(.system(size: 12, weight: .semibold))
                            }
                            
                            // Density Vapor + Temperature
                            HStack(spacing: 12) {
                                inputColumn(title: "Density Vapor", subtitle: "cu.ft./lbs.", value: $densityVapor).font(.system(size: 12, weight: .semibold))
                                inputColumn(title: "°F", subtitle: "", value: $temperature).font(.system(size: 12, weight: .semibold))
                            }
                            
                            // Buttons
                            HStack(spacing: 12) {
                                Button(action: clearAll) {
                                    Text("Clear")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.67, green: 0.84, blue: 1.0))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: goHome) {
                                    Text("Go to Home")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.20, green: 0.16, blue: 0.75))
                                        .cornerRadius(4)
                                }
                            }
                            .padding(.top, 4)
                            
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    .padding(.top, 16)
                    .background(Color(hex: "#90CFF2"))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // hide default arrow
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
            try? await Task.sleep(for: .seconds(0.3))
            withAnimation(.easeInOut(duration: 0.3)) {
                loadingManager.hide()
            }
        }
        .onChange(of: check_value){
            if !psig.isEmpty {
                let doubleValue = Double(psig)
                let isValid = doubleValue != nil && (-20.4...293.1).contains(doubleValue!)
                Task{
                    if isValid == true {
                        psia = ExcelDataModel.shared.PSIG_vlookup(lookupValue: psig, tableArray: PSIG_rows, columnIndex: 2) ?? ""
                        cvLiquid = ExcelDataModel.shared.PSIG_vlookup(lookupValue: psig, tableArray: PSIG_rows, columnIndex: 3) ?? ""
                        cvVapor = ExcelDataModel.shared.PSIG_vlookup(lookupValue: psig, tableArray: PSIG_rows, columnIndex: 4) ?? ""
                        densityLiquid = ExcelDataModel.shared.PSIG_vlookup(lookupValue: psig, tableArray: PSIG_rows, columnIndex: 5) ?? ""
                        densityVapor = ExcelDataModel.shared.PSIG_vlookup(lookupValue: psig, tableArray: PSIG_rows, columnIndex: 6) ?? ""
                        temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: psig, tableArray: PSIG_rows, columnIndex: 7) ?? ""
                    }
                }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    show_notification = !isValid
                }
            }
            
        }
    }
    
    // MARK: Helper Subview
    public func inputColumn(title: String, subtitle: String? = nil, value: Binding<String>) -> some View {
        let intValue = Int(value.wrappedValue)
        let isValid = intValue != nil && (1...100).contains(intValue!)
        
        
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            TextField("", text: value)
                .padding(10)
                .background(Color(hex: "#EEF6FB"))
                .cornerRadius(8)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 12))
                .disabled(true)
            
        }
    }
    
    // MARK: Actions
    private func clearAll() {
        psig = ""
        psia = ""
        cvLiquid = ""
        cvVapor = ""
        densityLiquid = ""
        densityVapor = ""
        temperature = ""
    }
    
    private func goHome() {
        dismiss()
    }
}



#Preview {
    PSIGView(path: .constant(NavigationPath()), headerText: "PSIGView")
}
