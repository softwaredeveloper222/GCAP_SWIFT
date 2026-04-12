//
//  PressureView.swift
//  GCAP
//
//  Created by admin on 11/6/25.
//

import SwiftUI

struct PressureView: View {
    @State private var input_first = ""
    @State private var input_second = ""
    @State private var input_third = ""
    @State private var input_forth = ""
    
    //MARK: first table variable
    @State private var A_1 = ""
    @State private var A_2 = ""
    @State private var A_3 = ""
    @State private var A_4 = ""
    
    @State private var B_1 = ""
    @State private var B_2 = ""
    @State private var B_3 = ""
    @State private var B_4 = ""
    
    @State private var C_1 = ""
    @State private var C_2 = ""
    @State private var C_3 = ""
    @State private var C_4 = ""
    @State private var C_5 = ""
    
    @State private var D_1 = ""
    @State private var D_2 = ""
    @State private var D_3 = ""
    @State private var D_4 = ""
    @State private var D_5 = ""
    
    @State private var E_1 = ""
    @State private var E_2 = ""
    @State private var E_3 = ""
    @State private var E_4 = ""
    @State private var E_5 = ""
    
    @State private var F_1 = ""
    @State private var F_2 = ""
    @State private var F_3 = ""
    @State private var F_4 = ""
    
    @State private var G_1 = ""
    @State private var G_2 = ""
    @State private var G_3 = ""
    @State private var G_4 = ""
    //
    
    @State private var Row_1 = ""
    @State private var Row_2 = ""
    @State private var Row_3 = ""
    @State private var Row_4 = ""
    @State private var Row_5 = ""
    @State private var Row_6 = ""
    @State private var Row_7 = ""
    @State private var Row_8 = ""
    @State private var Row_9 = ""
    //
    
    
    @State private var changedValue = 0
    
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
                ScrollView  {                // MARK: Form Card
                    VStack(alignment: .leading, spacing : 16){
                        Text("Pressure Enthalpy")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#3638A8"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            inputColumn(title: "Evaporator Temperature(°F)", subtitle: "", value: $input_first).font(.system(size: 12, weight: .semibold))
                            inputColumn(title: "Condensing Temperature(°F)", subtitle: "", value: $input_second).font(.system(size: 12, weight: .semibold))
                            
                            inputColumn(title: "Recirc.Pump Pressure(psig)", subtitle: "", value: $input_third).font(.system(size: 12, weight: .semibold))
                            inputColumn(title: "Compressor Suction Temp(°F)", subtitle: "", value: $input_forth).font(.system(size: 12, weight: .semibold))
                            
                            Image("pe")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                            
                            ThermodynamicTableView(A_1: $A_1, A_2: $A_2, A_3: $A_3, A_4: $A_4, B_1: $B_1, B_2: $B_2, B_3: $B_3, B_4: $B_4, C_1: $C_1, C_2: $C_2, C_3: $C_3, C_4: $C_4, C_5: $C_5, D_1: $D_1, D_2: $D_2, D_3: $D_3, D_4: $D_4, D_5: $D_5, E_1: $E_1, E_2: $E_2, E_3: $E_3, E_4: $E_4, E_5: $E_5, F_1: $F_1, F_2: $F_2, F_3: $F_3, F_4: $F_4, G_1: $G_1, G_2: $G_2, G_3: $G_3, G_4: $G_4)
                            //
                            RefrigerationParametersView(Row_1: $Row_1, Row_2: $Row_2, Row_3: $Row_3, Row_4: $Row_4, Row_5: $Row_5, Row_6: $Row_6, Row_7: $Row_7, Row_8: $Row_8, Row_9: $Row_9)
                            
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
                    dismiss() // 👈 go back
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
            loadingManager.show()

            // Give UI a frame to render loading
            try? await Task.sleep(nanoseconds: 100_000_000)

            await ExcelDataModel.shared.loadPressureExcel()

                loadingManager.hide()
        }
        .onChange(of: changedValue){
            if changedValue == 0{
                return
            }
            loadingManager.show()
            Task{
                //Column_1
                A_1 = formatValue(input_second)
                B_1 = formatValue(input_first)
                C_1 = formatValue(input_first)
                E_1 = formatValue(input_second)
                F_1 = formatValue(input_first)
                G_1 = formatValue(input_first)
                
                //
                G_3 = formatValue(input_third)
                
                
                //Column_2
                A_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: A_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
                B_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: B_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
                C_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
                D_2 = A_2
                E_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
                F_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: F_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
                G_2 = formatValue(ExcelDataModel.shared.PSIG_vlookup(lookupValue: G_3, tableArray: PSIG_rows, columnIndex: 2) ?? "")
                
                //Column_3
                A_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: A_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
                B_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: B_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
                C_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
                D_3 = A_3
                E_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
                F_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: F_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
                
                //Column_4
                A_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: A_1, tableArray: PSIF_rows, columnIndex: 8) ?? "")
                B_4 = A_4
                C_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 9) ?? "")
                D_4 = ""//recalc
                E_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 9) ?? "")
                F_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: F_1, tableArray: PSIF_rows, columnIndex: 8) ?? "")
                G_4 = F_4
                
                
                //Column_5
                let res1 = normalizeCellRef(vlookup(lookupValue: C_2, sheet: "Sheet3", startRef: "F1", endRef: "I182", colIndex: 3, workbook: wb) ?? "")
                let res2 = normalizeCellRef(vlookup(lookupValue: C_2, sheet: "Sheet3", startRef: "F1", endRef: "I182", colIndex: 4, workbook: wb) ?? "")
                
                let res3 = vlookup(lookupValue: input_forth, sheet: "Sheet2", startRef: res1, endRef: res2, colIndex: 6, workbook: wb) ?? ""
                
                C_5 = formatValue(res3)
                D_5 = C_5
                E_5 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 10) ?? "")
                
                let rest_cell1 = normalizeCellRef(vlookup(lookupValue: A_2, sheet: "Sheet3", startRef: "A1", endRef: "D82", colIndex: 3, workbook: wb) ?? "")
                let rest_cell2 = normalizeCellRef(vlookup(lookupValue: A_2, sheet: "Sheet3", startRef: "A1", endRef: "D82", colIndex: 4, workbook: wb) ?? "")
                let rest_d_1 = vlookup(lookupValue: D_5, sheet: "Sheet2", startRef: rest_cell1, endRef: rest_cell2, colIndex: 2, workbook: wb) ?? ""
                
                D_1 = formatValue(rest_d_1)
                
                let rest_d_4 = formatValue(vlookup(lookupValue: D_5, sheet: "Sheet2", startRef: rest_cell1, endRef: rest_cell2, colIndex: 6, workbook: wb) ?? "")
                
                D_4 = rest_d_4
                
                
                //Below Table
                let a = Double(C_4) ?? 0
                let b = Double(B_4) ?? 0
                Row_1 = formatValue(String(a - b))
                
                Row_2 = formatValue(D_1)
                
                let result = 200 / (a - b)
                Row_3 = formatValue(String(result))
                
                Row_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 5) ?? "")
                
                let d = Double(D_4) ?? 0//c_4
                Row_5 = formatValue(String((d - a) / 42.44 * result))
                
                let e = Double(Row_4) ?? 0
                Row_6 = formatValue(String(result * e))
                
                let g = Double(A_2) ?? 0
                let h = Double(C_2) ?? 0
                Row_7 = formatValue(String(g / h))
                
                let i = Double(F_4) ?? 0
                Row_8 = formatValue(String(a - i))
                
                Row_9 = formatValue(String(b - i))
                //
                
                loadingManager.hide()
            }
        }
    }
    
    // MARK: Helper Subview
    private func inputColumn(title: String, subtitle: String? = nil, value: Binding<String>) -> some View {
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
                .font(.system(size: 12))
                .keyboardType(.decimalPad)
                .onChange(of: value.wrappedValue) { newValue in
                    // Allow digits, one ".", and one "-" only at the start
                    var filtered = newValue.filter { $0.isNumber || $0 == "." || $0 == "-" }
                    
                    // If user typed "-" not at the beginning, move it or remove it
                    if filtered.contains("-") && !filtered.hasPrefix("-") {
                        filtered = filtered.replacingOccurrences(of: "-", with: "")
                    }
                    
                    // Prevent multiple "." (like "1.2.3")
                    let parts = filtered.split(separator: ".")
                    if parts.count > 2 {
                        filtered = parts[0] + "." + parts[1]
                    }
                    
                    // Update field only if filtered differs
                    if filtered != newValue {
                        value.wrappedValue = filtered
                    }
                }
                .onSubmit {
                    changedValue = Int(arc4random())
                }
        }
    }
    //
    
    private func formatValue(_ value: String?) -> String {
        guard let value = value,
              let doubleValue = Double(value) else { return value ?? "" }
        
        var str = String(format: "%.4f", doubleValue)
        
        while str.contains(".") && (str.hasSuffix("0") || str.hasSuffix(".")) {
            if str.hasSuffix("0") {
                str.removeLast()
            } else if str.hasSuffix(".") {
                str.removeLast()
                break
            }
        }
        
        return str
    }
    // MARK: Actions
    private func clearAll() {
        input_first = ""
        input_second = ""
        input_third = ""
        input_forth = ""
        
        changedValue = Int(arc4random())
    }
    
    private func goHome() {
        loadingManager.show()
        Task{
            //Column_1
            A_1 = formatValue(input_second)
            B_1 = formatValue(input_first)
            C_1 = formatValue(input_first)
            E_1 = formatValue(input_second)
            F_1 = formatValue(input_first)
            G_1 = formatValue(input_first)
            
            //
            G_3 = formatValue(input_third)
            
            
            //Column_2
            A_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: A_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
            B_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: B_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
            C_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
            D_2 = A_2
            E_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
            F_2 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: F_1, tableArray: PSIF_rows, columnIndex: 3) ?? "")
            G_2 = formatValue(ExcelDataModel.shared.PSIG_vlookup(lookupValue: G_3, tableArray: PSIG_rows, columnIndex: 2) ?? "")
            
            //Column_3
            A_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: A_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
            B_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: B_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
            C_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
            D_3 = A_3
            E_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
            F_3 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: F_1, tableArray: PSIF_rows, columnIndex: 2) ?? "")
            
            //Column_4
            A_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: A_1, tableArray: PSIF_rows, columnIndex: 8) ?? "")
            B_4 = A_4
            C_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 9) ?? "")
            D_4 = ""//recalc
            E_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 9) ?? "")
            F_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: F_1, tableArray: PSIF_rows, columnIndex: 8) ?? "")
            G_4 = F_4
            
            
            //Column_5
            let res1 = normalizeCellRef(vlookup(lookupValue: C_2, sheet: "Sheet3", startRef: "F1", endRef: "I182", colIndex: 3, workbook: wb) ?? "")
            let res2 = normalizeCellRef(vlookup(lookupValue: C_2, sheet: "Sheet3", startRef: "F1", endRef: "I182", colIndex: 4, workbook: wb) ?? "")
            
            let res3 = vlookup(lookupValue: input_forth, sheet: "Sheet2", startRef: res1, endRef: res2, colIndex: 6, workbook: wb) ?? ""
            
            C_5 = formatValue(res3)
            D_5 = C_5
            E_5 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: E_1, tableArray: PSIF_rows, columnIndex: 10) ?? "")
            
            let rest_cell1 = normalizeCellRef(vlookup(lookupValue: A_2, sheet: "Sheet3", startRef: "A1", endRef: "D82", colIndex: 3, workbook: wb) ?? "")
            let rest_cell2 = normalizeCellRef(vlookup(lookupValue: A_2, sheet: "Sheet3", startRef: "A1", endRef: "D82", colIndex: 4, workbook: wb) ?? "")
            let rest_d_1 = vlookup(lookupValue: D_5, sheet: "Sheet2", startRef: rest_cell1, endRef: rest_cell2, colIndex: 2, workbook: wb) ?? ""
            
            D_1 = formatValue(rest_d_1)
            
            let rest_d_4 = formatValue(vlookup(lookupValue: D_5, sheet: "Sheet2", startRef: rest_cell1, endRef: rest_cell2, colIndex: 6, workbook: wb) ?? "")
            
            D_4 = rest_d_4
            
            
            //Below Table
            let a = Double(C_4) ?? 0
            let b = Double(B_4) ?? 0
            Row_1 = formatValue(String(a - b))
            
            Row_2 = formatValue(D_1)
            
            let result = 200 / (a - b)
            Row_3 = formatValue(String(result))
            
            Row_4 = formatValue(ExcelDataModel.shared.PSIF_vlookup(lookupValue: C_1, tableArray: PSIF_rows, columnIndex: 5) ?? "")
            
            let d = Double(D_4) ?? 0//c_4
            Row_5 = formatValue(String((d - a) / 42.44 * result))
            
            let e = Double(Row_4) ?? 0
            Row_6 = formatValue(String(result * e))
            
            let g = Double(A_2) ?? 0
            let h = Double(C_2) ?? 0
            Row_7 = formatValue(String(g / h))
            
            let i = Double(F_4) ?? 0
            Row_8 = formatValue(String(a - i))
            
            Row_9 = formatValue(String(b - i))
            //
            
            loadingManager.hide()
        }
//        dismiss()
    }
    
}



#Preview {
    PressureView(path: .constant(NavigationPath()), headerText: "PressureView")
}
