//
//  ThermodynamicTableView.swift
//  Shooki
//
//  Created on 6/22/25.
//

import SwiftUI

struct ThermodynamicTableView: View {
    
    @Binding var A_1: String
    @Binding var A_2: String
    @Binding var A_3: String
    @Binding var A_4: String
    
    @Binding var B_1: String
    @Binding var B_2: String
    @Binding var B_3: String
    @Binding var B_4: String
    
    @Binding var C_1: String
    @Binding var C_2: String
    @Binding var C_3: String
    @Binding var C_4: String
    @Binding var C_5: String
    
    @Binding var D_1: String
    @Binding var D_2: String
    @Binding var D_3: String
    @Binding var D_4: String
    @Binding var D_5: String
    
    @Binding var E_1: String
    @Binding var E_2: String
    @Binding var E_3: String
    @Binding var E_4: String
    @Binding var E_5: String
    
    @Binding var F_1: String
    @Binding var F_2: String
    @Binding var F_3: String
    @Binding var F_4: String
    
    @Binding var G_1: String
    @Binding var G_2: String
    @Binding var G_3: String
    @Binding var G_4: String
    
    var points: [ThermodynamicPoint] {
        [
            ThermodynamicPoint(
                point: "A",
                temperatureF: Double(A_1) ?? 0,
                psia: Double(A_2) ?? 0,
                psig: Double(A_3) ?? 0,
                enthalpy: Double(A_4) ?? 0,
                entropy: nil,
                rowColor: .lightBlue
            ),
            ThermodynamicPoint(
                point: "B",
                temperatureF: Double(B_1) ?? 0,
                psia: Double(B_2) ?? 0,
                psig: Double(B_3) ?? 0,
                enthalpy: Double(B_4) ?? 0,
                entropy: nil,
                rowColor: .lightBlue
            ),
            ThermodynamicPoint(
                point: "C",
                temperatureF: Double(C_1) ?? 0,
                psia: Double(C_2) ?? 0,
                psig: Double(C_3) ?? 0,
                enthalpy: Double(C_4) ?? 0,
                entropy: Double(C_5) ?? 0,
                rowColor: .mediumBlue
            ),
            ThermodynamicPoint(
                point: "D",
                temperatureF: Double(D_1) ?? 0,
                psia: Double(D_2) ?? 0,
                psig: Double(D_3) ?? 0,
                enthalpy: Double(D_4) ?? 0,
                entropy: Double(D_5) ?? 0,
                rowColor: .orange
            ),
            ThermodynamicPoint(
                point: "E",
                temperatureF: Double(E_1) ?? 0,
                psia: Double(E_2) ?? 0,
                psig: Double(E_3) ?? 0,
                enthalpy: Double(E_4) ?? 0,
                entropy: Double(E_5) ?? 0,
                rowColor: .yellow
            ),
            ThermodynamicPoint(
                point: "F",
                temperatureF: Double(F_1) ?? 0,
                psia: Double(F_2) ?? 0,
                psig: Double(F_3) ?? 0,
                enthalpy: Double(F_4) ?? 0,
                entropy: nil,
                rowColor: .lightBlue
            ),
            ThermodynamicPoint(
                point: "G",
                temperatureF: Double(G_1) ?? 0,
                psia: Double(G_2) ?? 0,
                psig: Double(G_3) ?? 0,
                enthalpy: Double(G_4) ?? 0,
                entropy: nil,
                rowColor: .lightBlue
            )
        ]
    }

    
    var body: some View {
        VStack{
            GeometryReader{ geo in
                VStack(spacing: 0) {
                    // Header row
                    HStack(spacing: 0) {
                        headerCell(geo.size.width * 0.15, "Point")
                        headerCell(geo.size.width * 0.12,  "°F")
                        headerCell(geo.size.width * 0.15, "psia")
                        headerCell(geo.size.width * 0.15, "psig")
                        headerCell(geo.size.width * 0.23, "Enthalpy")
                        headerCell(geo.size.width * 0.2,"Entropy")
                    }
                    .background(Color.white)
                    
                    ForEach(points) { point in
                        HStack(spacing: 0) {
                            dataCell(geo.size.width * 0.15, point.point, color: point.rowColor.mainColor, isPointColumn: true)
                            dataCell(geo.size.width * 0.12, formatNumber(point.temperatureF), color: point.rowColor.mainColor)
                            dataCell(geo.size.width * 0.15, formatNumber(point.psia), color: point.rowColor.mainColor)
                            dataCell(geo.size.width * 0.15, formatNumber(point.psig), color: point.rowColor.mainColor)
                            dataCell(geo.size.width * 0.23, formatNumber(point.enthalpy), color: point.rowColor.mainColor)
                            dataCell(geo.size.width * 0.2, formatNumber(point.entropy ?? 0), color: point.rowColor.entropyColor)
                        }
                    }
                }
                .border(Color.black, width: 1)
            }
        }
        .frame(height: 280)
    }
    
    @ViewBuilder
    private func headerCell(_ header_width: Double, _ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, minHeight: 35)
            .background(Color.white)
            .frame(width: header_width)
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 1)
            )
    }
    
    @ViewBuilder
    private func dataCell(_ cell_width: Double, _ text: String, color: Color, isShaded: Bool = false, isPointColumn: Bool = false) -> some View {
        ZStack {
            color
            
            if isShaded {
                CrosshatchPattern()
                    .stroke(Color.blue.opacity(0.4), lineWidth: 0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if !isShaded {
                Text(text)
                    .font(.system(size: 11, weight: isPointColumn ? .medium : .regular))
                    .foregroundColor(.black)
            }
        }
        .frame(width: cell_width, height: 35)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 1)
        )
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value == 0 {
            return ""
        }
        
        var str = String(format: "%.4f", value)
        
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
}

// Preview
//struct ThermodynamicTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThermodynamicTableView()
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}

