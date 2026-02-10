//
//  RefrigerationParametersView.swift
//  Shooki
//
//  Created on 6/22/25.
//

import SwiftUI

struct RefrigerationParametersView: View {
    @Binding var Row_1: String
    @Binding var Row_2: String
    @Binding var Row_3: String
    @Binding var Row_4: String
    @Binding var Row_5: String
    @Binding var Row_6: String
    @Binding var Row_7: String
    @Binding var Row_8: String
    @Binding var Row_9: String
    
    
    
    // Sample data matching the image
    var parameters: [RefrigerationParameter] {
        [
            .init(parameter: "Refrigerating Effect", value: "\(Row_1) Btu/Lb"),
            .init(parameter: "Theoretical Discharge Temp", value: "\(Row_2) °F"),
            .init(parameter: "Mass Flow Rate", value: "\(Row_3) Lbs/min"),
            .init(parameter: "Constant Volume Suction", value: "\(Row_4) CuFt/Lb"),
            .init(parameter: "Theoretical Horsepower/Ton", value: "\(Row_5) BHP"),
            .init(parameter: "Compressor CFM/Ton", value: "\(Row_6) CFM/Ton"),
            .init(parameter: "Compression Ratio", value: "\(Row_7) : 1"),
            .init(parameter: "Latent Heat Of Vaporization", value: "\(Row_8) Btu/Lb"),
            .init(parameter: "Non-Refrigerating Effect", value: "\(Row_9) Btu/Lb")
        ]
    }

    
    private let darkerGreen = Color(red: 0.57, green: 0.82, blue: 0.31)
    private let lighterGreen = Color(red: 0.78, green: 0.88, blue: 0.71)
    
    var body: some View {
        VStack(spacing: 0) {
                ForEach(parameters) { param in
                    
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            
                            Text(param.parameter)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.black)
                                .frame(width: geo.size.width * 0.6, alignment: .center)
                                .padding(.vertical, 13)
                                .background(Color(hex: "#00FF00"))
                                .overlay(
                                    Rectangle()
                                        .frame(width: 1)
                                        .foregroundColor(.black),
                                    alignment: .trailing
                                )
                            
                            Text(param.value)
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.black)
                                .frame(width: geo.size.width * 0.4, alignment: .center)
                                .padding(.vertical, 13)
                                .background(Color(hex: "#C7E0B5"))
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black),
                            alignment: .bottom
                        )
                    }
                    .frame(height: 40)
                }
            }
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

// Preview
//struct RefrigerationParametersView_Previews: PreviewProvider {
//    static var previews: some View {
//        RefrigerationParametersView()
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}

