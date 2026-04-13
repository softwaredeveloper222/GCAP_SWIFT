//
//  ReleaseView.swift
//  GCAP
//
//  Created by admin on 11/6/25.
//

import SwiftUI

struct ReleaseView: View {
    
    //MARK: card-1
    @State private var Liquid_realease_Round_opening_Diameter = ""
    @State private var Liquid_realease_Round_opening_Gauge = ""
    @State private var Liquid_realease_Round_opening_Number = ""
    @State private var Liquid_realease_Round_opening_Liquid_flow_rate = ""
    @State private var Liquid_realease_Round_opening_Liquid_flow_Total_liquid_released = ""
    //MARK: card-2
    @State private var Liquid_realease_Irregular_release_Area_of_leak = ""
    @State private var Liquid_realease_Irregular_release_Gauge = ""
    @State private var Liquid_realease_Irregular_release_Number = ""
    @State private var Liquid_realease_Irregular_release_Liquid_flow_rate = ""
    @State private var Liquid_realease_Irregular_release_Liquid_flow_Total_liquid_released = ""
    //MARK: card-3
    @State private var Gas_realease_Round_opening_Diameter = ""
    @State private var Gas_realease_Round_opening_Gauge = ""
    @State private var Gas_realease_Round_opening_Number = ""
    @State private var Gas_realease_Round_opening_Liquid_flow_rate = ""
    @State private var Gas_realease_Round_opening_Liquid_flow_Total_liquid_released = ""
    //MARK: card-4
    @State private var Gas_realease_Irregular_release_Area_of_leak = ""
    @State private var Gas_realease_Irregular_release_Gauge = ""
    @State private var Gas_realease_Irregular_release_Number = ""
    @State private var Gas_realease_Irregular_release_Liquid_flow_rate = ""
    @State private var Gas_realease_Irregular_release_Liquid_flow_Total_liquid_released = ""
    //MARK: card-5
    @State private var Room_level_Length_of_room = ""
    @State private var Room_level_Height_of_room = ""
    @State private var Room_level_Width_of_room_1 = ""
    @State private var Room_level_Width_of_room_2 = ""
    @State private var Room_level_Width_of_room_3 = ""
    @State private var Room_level_Total_room_value = ""
    @State private var Room_level_Vapor_density = ""
    @State private var Room_level_Total_nh3 = ""
    
    
    @State private var changed_first_card = 0
    @State private var changed_second_card = 0
    @State private var changed_third_card = 0
    @State private var changed_forth_card = 0
    @State private var changed_fifth_card = 0
    
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
//    init(path: Binding<NavigationPath>, headerText: String) {
//        self._path = path
//        self.headerText = headerText
//        loadingManager.show()
//    }

    
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
                        Text("Liquid Release - Round Opening")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(changed_card: $changed_first_card, title: "Diameter of Round Hole (In Inches)", subtitle: "", value: $Liquid_realease_Round_opening_Diameter).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_first_card, title: "Gauge Pressure (psig)", subtitle: "", value: $Liquid_realease_Round_opening_Gauge).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_first_card, title: "Number of Minutes Released", subtitle: "", value: $Liquid_realease_Round_opening_Number).font(.system(size: 12, weight: .semibold))
                            
                            HStack{
                                textColumn(title: "Liquid Flow Rate(lb/min)", value: $Liquid_realease_Round_opening_Liquid_flow_rate)
                                textColumn(title: "Total Liquid Released(lb)", value: $Liquid_realease_Round_opening_Liquid_flow_Total_liquid_released)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: clearLiquidRealeaseRoundOpening) {
                                    Text("Clear")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.67, green: 0.84, blue: 1.0))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: goHome_1) {
                                    Text("Calculate")
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
                    
                    Spacer().frame(height: 20)
                    
                    VStack(alignment: .leading, spacing : 16){
                        Text("Liquid Realease - Irregular Opening")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(changed_card: $changed_second_card, title: "Area of Leak (In Square Inches)", subtitle: "", value: $Liquid_realease_Irregular_release_Area_of_leak).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_second_card, title: "Gauge Pressure (psig)", subtitle: "", value: $Liquid_realease_Irregular_release_Gauge).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_second_card, title: "Number of Minutes Released", subtitle: "", value: $Liquid_realease_Irregular_release_Number).font(.system(size: 12, weight: .semibold))
                            
                            HStack{
                                textColumn(title: "Liquid Flow Rate(lb/min)", value: $Liquid_realease_Irregular_release_Liquid_flow_rate)
                                textColumn(title: "Total Liquid Released(lb)", value: $Liquid_realease_Irregular_release_Liquid_flow_Total_liquid_released)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: clearLiquidRealeaseIrregularOpening) {
                                    Text("Clear")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.67, green: 0.84, blue: 1.0))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: goHome_2) {
                                    Text("Calculate")
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
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment: .leading, spacing : 16){
                        Text("Gas Realease - Round Opening")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(changed_card: $changed_third_card, title: "Diameter of Round Hole (In Inches)", subtitle: "", value: $Gas_realease_Round_opening_Diameter).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_third_card, title: "Gauge Pressure (psig)", subtitle: "", value: $Gas_realease_Round_opening_Gauge).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_third_card, title: "Number of Minutes Released", subtitle: "", value: $Gas_realease_Round_opening_Number).font(.system(size: 12, weight: .semibold))
                            
                            HStack{
                                textColumn(title: "Gas Flow Rate(lb/min)", value: $Gas_realease_Round_opening_Liquid_flow_rate)
                                textColumn(title: "Total Vapor Released(lb)", value: $Gas_realease_Round_opening_Liquid_flow_Total_liquid_released)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: clearGasRealeaseRoundOpening) {
                                    Text("Clear")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.67, green: 0.84, blue: 1.0))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: goHome_3) {
                                    Text("Calculate")
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
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment: .leading, spacing : 16){
                        Text("Gas Realease - Irregular Opening")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(changed_card: $changed_forth_card, title: "Area of Leak (In Square Inches)", subtitle: "", value: $Gas_realease_Irregular_release_Area_of_leak).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_forth_card, title: "Gauge Pressure (psig)", subtitle: "", value: $Gas_realease_Irregular_release_Gauge).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_forth_card, title: "Number of Minutes Released", subtitle: "", value: $Gas_realease_Irregular_release_Number).font(.system(size: 12, weight: .semibold))
                            
                            HStack{
                                textColumn(title: "Gas Flow Rate(lb/min", value: $Gas_realease_Irregular_release_Liquid_flow_rate)
                                textColumn(title: "Total Vapor Released(lb)", value: $Gas_realease_Irregular_release_Liquid_flow_Total_liquid_released)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: clearGasRealeaseIrregularOpening) {
                                    Text("Clear")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.67, green: 0.84, blue: 1.0))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: goHome_4) {
                                    Text("Calculate")
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
                    
                    Spacer().frame(height: 30)
                    
                    VStack(alignment: .leading, spacing : 16){
                        Text("Room Level - PPM to lbs")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(changed_card: $changed_fifth_card, title: "Length of room (in feet)", subtitle: "", value: $Room_level_Length_of_room).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_fifth_card, title: "height of room (in feet)", subtitle: "", value: $Room_level_Height_of_room).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_fifth_card, title: "Width of room (in feet)", subtitle: "", value: $Room_level_Width_of_room_1).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_fifth_card, title: "Width of room (in feet)", subtitle: "", value: $Room_level_Width_of_room_2).font(.system(size: 12, weight: .semibold))
                            inputColumn(changed_card: $changed_fifth_card, title: "Width of room (in feet)", subtitle: "", value: $Room_level_Width_of_room_3).font(.system(size: 12, weight: .semibold))
                            
                            VStack{
                                textColumn(title: "Total room value in ft3", value: $Room_level_Total_room_value)
                                textColumn(title: "Vapor density", value: $Room_level_Vapor_density)
                                textColumn(title: "Total NH3 in lbs", value: $Room_level_Total_nh3)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: clearRoomLevel) {
                                    Text("Clear")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 12)
                                        .padding(.bottom, 12)
                                        .background(Color(red: 0.67, green: 0.84, blue: 1.0))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: goHome_5) {
                                    Text("Calculate")
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
        .onChange(of: changed_first_card){
            
            let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Liquid_realease_Round_opening_Gauge, tableArray: PSIG_rows, columnIndex: 5) ?? "0"
            
            let a = Double(Liquid_realease_Round_opening_Diameter) ?? 0
            let b = Double(Liquid_realease_Round_opening_Number) ?? 0
            let c = Double(Liquid_realease_Round_opening_Gauge) ?? 0
            let d = Double(temperature) ?? 0
            
            let LiquidFlowRate = 26.81 * a * a * sqrt(c * d)
            
            let TotalLiquidReleased = LiquidFlowRate * b
            
            Liquid_realease_Round_opening_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
            Liquid_realease_Round_opening_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
        }
        .onChange(of: changed_second_card){
            
            let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Liquid_realease_Irregular_release_Gauge, tableArray: PSIG_rows, columnIndex: 5) ?? "0"
            
            let a = Double(Liquid_realease_Irregular_release_Area_of_leak) ?? 0
            let b = Double(Liquid_realease_Irregular_release_Number) ?? 0
            let c = Double(Liquid_realease_Irregular_release_Gauge) ?? 0
            let d = Double(temperature) ?? 0
            
            let LiquidFlowRate = 34.133 * a * sqrt(c * d)
            
            let TotalLiquidReleased = LiquidFlowRate * b
            
            Liquid_realease_Irregular_release_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
            Liquid_realease_Irregular_release_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
        }
        .onChange(of: changed_third_card){
            let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Gas_realease_Round_opening_Gauge, tableArray: PSIG_rows, columnIndex: 7) ?? "0"
            
            let a = Double(Gas_realease_Round_opening_Diameter) ?? 0
            let b = Double(Gas_realease_Round_opening_Number) ?? 0
            let c = Double(Gas_realease_Round_opening_Gauge) ?? 0
            let d = Double(temperature) ?? 0
            
            var LiquidFlowRate: Double = 0
            
            if c > 0 {
                LiquidFlowRate = (15.48 * a * a * (c + 14.7) * c) / (sqrt(d + 459) * c)
            }
            
            let TotalLiquidReleased = LiquidFlowRate * b
            
            Gas_realease_Round_opening_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
            Gas_realease_Round_opening_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
        }
        .onChange(of: changed_forth_card){
            let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Gas_realease_Irregular_release_Gauge, tableArray: PSIG_rows, columnIndex: 7) ?? "0"
            
            let a = Double(Gas_realease_Irregular_release_Area_of_leak) ?? 0
            let b = Double(Gas_realease_Irregular_release_Number) ?? 0
            let c = Double(Gas_realease_Irregular_release_Gauge) ?? 0
            let d = Double(temperature) ?? 0
            
            var LiquidFlowRate: Double = 0
            
            if c > 0 {
                LiquidFlowRate = (19.71 * a * (c + 14.66)) / sqrt(d + 459)
            }
            
            let TotalLiquidReleased = LiquidFlowRate * b
            
            Gas_realease_Irregular_release_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
            Gas_realease_Irregular_release_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
        }
        .onChange(of: changed_fifth_card){
            let temperature = ExcelDataModel.shared.PSIF_vlookup(lookupValue: Room_level_Width_of_room_2, tableArray: PSIF_rows, columnIndex: 7) ?? "0"
            
            let a = Double(Room_level_Length_of_room) ?? 0
            let b = Double(Room_level_Height_of_room) ?? 0
            let c = Double(Room_level_Width_of_room_1) ?? 0
            let d = Double(Room_level_Width_of_room_2) ?? 0
            let e = Double(Room_level_Width_of_room_3) ?? 0
            let f = Double(temperature) ?? 0
            
            let result = a * b * c
            
            let result1 = result * f * (e / 1000000)
            
            Room_level_Total_room_value =  ExcelDataModel.shared.formatValue(String(result)) ?? ""
            
            Room_level_Vapor_density = ExcelDataModel.shared.formatValue(temperature) ?? ""
            
            Room_level_Total_nh3 = String(result1)
        }
    }
    
    // MARK: Helper Subview
    private func inputColumn(changed_card: Binding<Int>, title: String, subtitle: String? = nil, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
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
                .multilineTextAlignment(.leading)
                .onSubmit {
                    changed_card.wrappedValue = Int(arc4random())
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
                .foregroundStyle(Color.black)
                .cornerRadius(8)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 12, weight: .semibold))
                .disabled(true)
        }
    }
    
    // MARK: clearLiquidRealeaseRoundOpening
    private func clearLiquidRealeaseRoundOpening() {
        Liquid_realease_Round_opening_Diameter = ""
        Liquid_realease_Round_opening_Gauge = ""
        Liquid_realease_Round_opening_Number = ""
        Liquid_realease_Round_opening_Liquid_flow_rate = ""
        Liquid_realease_Round_opening_Liquid_flow_Total_liquid_released = ""
    }
    // MARK: clearLiquidRealeaseIrregularOpening
    private func clearLiquidRealeaseIrregularOpening() {
        Liquid_realease_Irregular_release_Area_of_leak = ""
        Liquid_realease_Irregular_release_Gauge = ""
        Liquid_realease_Irregular_release_Number = ""
        Liquid_realease_Irregular_release_Liquid_flow_rate = ""
        Liquid_realease_Irregular_release_Liquid_flow_Total_liquid_released = ""
    }
    // MARK: clearGasRealeaseRoundOpening
    private func clearGasRealeaseRoundOpening() {
        Gas_realease_Round_opening_Diameter = ""
        Gas_realease_Round_opening_Gauge = ""
        Gas_realease_Round_opening_Number = ""
        Gas_realease_Round_opening_Liquid_flow_rate = ""
        Gas_realease_Round_opening_Liquid_flow_Total_liquid_released = ""
    }
    // MARK: clearGasRealeaseIrregularOpening
    private func clearGasRealeaseIrregularOpening() {
        Gas_realease_Irregular_release_Area_of_leak = ""
        Gas_realease_Irregular_release_Gauge = ""
        Gas_realease_Irregular_release_Number = ""
        Gas_realease_Irregular_release_Liquid_flow_rate = ""
        Gas_realease_Irregular_release_Liquid_flow_Total_liquid_released = ""
    }
    // MARK: clearRoomLevel
    private func clearRoomLevel() {
        Room_level_Length_of_room = ""
        Room_level_Height_of_room = ""
        Room_level_Width_of_room_1 = ""
        Room_level_Width_of_room_2 = ""
        Room_level_Width_of_room_3 = ""
        Room_level_Total_room_value = ""
        Room_level_Vapor_density = ""
        Room_level_Total_nh3 = ""
    }
    
    private func goHome_1() {
        let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Liquid_realease_Round_opening_Gauge, tableArray: PSIG_rows, columnIndex: 5) ?? "0"
        
        let a = Double(Liquid_realease_Round_opening_Diameter) ?? 0
        let b = Double(Liquid_realease_Round_opening_Number) ?? 0
        let c = Double(Liquid_realease_Round_opening_Gauge) ?? 0
        let d = Double(temperature) ?? 0
        
        let LiquidFlowRate = 26.81 * a * a * sqrt(c * d)
        
        let TotalLiquidReleased = LiquidFlowRate * b
        
        Liquid_realease_Round_opening_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
        Liquid_realease_Round_opening_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
    }
    private func goHome_2() {
        let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Liquid_realease_Irregular_release_Gauge, tableArray: PSIG_rows, columnIndex: 5) ?? "0"
        
        let a = Double(Liquid_realease_Irregular_release_Area_of_leak) ?? 0
        let b = Double(Liquid_realease_Irregular_release_Number) ?? 0
        let c = Double(Liquid_realease_Irregular_release_Gauge) ?? 0
        let d = Double(temperature) ?? 0
        
        let LiquidFlowRate = 34.133 * a * sqrt(c * d)
        
        let TotalLiquidReleased = LiquidFlowRate * b
        
        Liquid_realease_Irregular_release_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
        Liquid_realease_Irregular_release_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
    }
    private func goHome_3() {
        let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Gas_realease_Round_opening_Gauge, tableArray: PSIG_rows, columnIndex: 7) ?? "0"
        
        let a = Double(Gas_realease_Round_opening_Diameter) ?? 0
        let b = Double(Gas_realease_Round_opening_Number) ?? 0
        let c = Double(Gas_realease_Round_opening_Gauge) ?? 0
        let d = Double(temperature) ?? 0
        
        var LiquidFlowRate: Double = 0
        
        if c > 0 {
            LiquidFlowRate = (15.48 * a * a * (c + 14.7) * c) / (sqrt(d + 459) * c)
        }
        
        let TotalLiquidReleased = LiquidFlowRate * b
        
        Gas_realease_Round_opening_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
        Gas_realease_Round_opening_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
    }
    private func goHome_4() {
        let temperature = ExcelDataModel.shared.PSIG_vlookup(lookupValue: Gas_realease_Irregular_release_Gauge, tableArray: PSIG_rows, columnIndex: 7) ?? "0"
        
        let a = Double(Gas_realease_Irregular_release_Area_of_leak) ?? 0
        let b = Double(Gas_realease_Irregular_release_Number) ?? 0
        let c = Double(Gas_realease_Irregular_release_Gauge) ?? 0
        let d = Double(temperature) ?? 0
        
        var LiquidFlowRate: Double = 0
        
        if c > 0 {
            LiquidFlowRate = (19.71 * a * (c + 14.66)) / sqrt(d + 459)
        }
        
        let TotalLiquidReleased = LiquidFlowRate * b
        
        Gas_realease_Irregular_release_Liquid_flow_rate =  ExcelDataModel.shared.formatValue(String(LiquidFlowRate)) ?? ""
        Gas_realease_Irregular_release_Liquid_flow_Total_liquid_released = ExcelDataModel.shared.formatValue(String(TotalLiquidReleased)) ?? ""
    }
    private func goHome_5() {
        let temperature = ExcelDataModel.shared.PSIF_vlookup(lookupValue: Room_level_Width_of_room_2, tableArray: PSIF_rows, columnIndex: 7) ?? "0"
        
        let a = Double(Room_level_Length_of_room) ?? 0
        let b = Double(Room_level_Height_of_room) ?? 0
        let c = Double(Room_level_Width_of_room_1) ?? 0
        let d = Double(Room_level_Width_of_room_2) ?? 0
        let e = Double(Room_level_Width_of_room_3) ?? 0
        let f = Double(temperature) ?? 0
        
        let result = a * b * c
        
        let result1 = result * f * (e / 1000000)
        
        Room_level_Total_room_value =  ExcelDataModel.shared.formatValue(String(result)) ?? ""
        
        Room_level_Vapor_density = ExcelDataModel.shared.formatValue(temperature) ?? ""
        
        Room_level_Total_nh3 = String(result1)
    }
}

#Preview {
    ReleaseView(path: .constant(NavigationPath()), headerText: "ReleaseView")
}
