//
//  SuperheatView.swift
//  GCAP
//
//  Created by admin on 11/6/25.
//

import SwiftUI

struct SuperheatView: View {
    
    //MARK: card-1
    @State private var Pressure = ""
    @State private var Temperature = ""
    @State private var SAT_Temperature = ""
    @State private var Condition = ""
    @State private var Degrees = ""
    
    @State private var chageValue = 0
    
    @State private var condition_flag = "#EEF6FB"
        
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
        }
    }
    
    var contentView: some View{
        ZStack {
            HeaderView(headerText: headerText)
            
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size + 20)
                ScrollView  {
                    VStack(alignment: .leading, spacing : 16){
                        Text("Superheat-Subcooling")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(title: "Pressure (PSIG)", subtitle: "", value: $Pressure).font(.system(size: 12, weight: .semibold))
                            inputColumn(title: "Temperature (°F)", subtitle: "", value: $Temperature).font(.system(size: 12, weight: .semibold))
                            
                            VStack(alignment: .leading, spacing: 16){
                                textColumn(title: "SAT Temperature (°F)(+ or -1 degree)", value: $SAT_Temperature)
                                conditionTextColumn(title: "Condition of Refrigerant", value: $Condition)
                                textColumn(title: "Degrees of Superheat/Subcooling (°F)(+ or -1 degree)", value: $Degrees)
                            }
                            
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
                                    Text("Go to")
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
                            
                            Text("The NH3 saturation chart is developed in 1 °F increments and then matched with hthe corresponding pressure. Therefore, the pressures do not increment by 1 PSIG. The calculator takes the pressure the user inputs and finds the closest pressure listed on the saturation chart to do the calculation.")
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                            
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
                }
                .padding(.bottom, 30)
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
            try? await Task.sleep(for: .seconds(0.3))
            withAnimation(.easeInOut(duration: 0.3)) {
                loadingManager.hide()
            }
        }
        .onChange(of: chageValue){
            let temperature = ExcelDataModel.shared.Superheat_vlookup(lookupValue: Pressure, tableArray: Superheat_rows, columnIndex: 2) ?? "0"
            
            let b = Double(Temperature) ?? 0
            let c = Double(temperature) ?? 0
            
            var degree_value: Double = 0
            
            if b > c {
                condition_flag = "#FF0000"
                degree_value = b - c
                Condition = "SUPERHEATED"
            }
            else{
                condition_flag = "#0000FF"
                degree_value = c - b
                Condition = "SUBCOLLED"
            }
            
            SAT_Temperature = String(c)
            Degrees = String(degree_value)
        }
    }
    
    // MARK: Helper Subview
    private func inputColumn(title: String, subtitle: String? = nil, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            TextField("", text: value)
                .padding(10)
                .background(Color(hex: "#F9F9F9"))
                .foregroundStyle(Color.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 12, weight: .semibold))
                .keyboardType(.decimalPad)
                .onChange(of: value.wrappedValue) { newValue in
                    var filtered = newValue.filter { $0.isNumber || $0 == "." || $0 == "-" }
                    
                    if filtered.contains("-") && !filtered.hasPrefix("-") {
                        filtered = filtered.replacingOccurrences(of: "-", with: "")
                    }
                    
                    let parts = filtered.split(separator: ".")
                    if parts.count > 2 {
                        filtered = parts[0] + "." + parts[1]
                    }
                    
                    if filtered != newValue {
                        value.wrappedValue = filtered
                    }
                }
                .onSubmit {
                    chageValue = Int(arc4random())
                }
        }
    }
    
    private func textColumn(title: String, subtitle: String? = nil, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
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
                .font(.system(size: 12, weight: .semibold))
                .disabled(true)
                .onAppear{
                    
                }
        }
    }
    
    private func conditionTextColumn(title: String, subtitle: String? = nil, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            TextField("", text: value)
                .padding(10)
                .background(Color(hex: condition_flag))
                .cornerRadius(8)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 12, weight: .semibold))
                .disabled(true)
                .foregroundColor(Color.white)
        }
    }
    
    private func clearAll() {
        Pressure = ""
        Temperature = ""
        SAT_Temperature = ""
        Condition = ""
        condition_flag = "#EEF6FB"
        Degrees = ""
    }
    
    private func goHome() {
        let temperature = ExcelDataModel.shared.Superheat_vlookup(lookupValue: Pressure, tableArray: Superheat_rows, columnIndex: 2) ?? "0"
        
        let b = Double(Temperature) ?? 0
        let c = Double(temperature) ?? 0
        
        var degree_value: Double = 0
        
        if b > c {
            condition_flag = "#FF0000"
            degree_value = b - c
            Condition = "SUPERHEATED"
        }
        else{
            condition_flag = "#0000FF"
            degree_value = c - b
            Condition = "SUBCOLLED"
        }
        
        SAT_Temperature = String(c)
        Degrees = String(degree_value)
//        dismiss()
    }
}

#Preview {
    SuperheatView(path: .constant(NavigationPath()), headerText: "SuperheatView")
}
