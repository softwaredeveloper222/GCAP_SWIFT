//
//  FormulasView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct FormulasView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    init(path: Binding<NavigationPath>, headerText: String) {
        self._path = path
        self.headerText = headerText
        loadingManager.show()
    }
    
    //MARK: mainview
    var body: some View {
        ZStack{
            contentView
            
            if loadingManager.isLoading {
                LoadingOverlayView()
            }
        }
    }
    
    //MARK: contentview
    var contentView: some View {
        ZStack{
            HeaderView(headerText: headerText)
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size + 20)
                Text("Quick Reference Formula Sheet")
                    .foregroundColor(Color(hex: "#255181")).font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, weight: .semibold))
                ScrollView{
                    VStack(alignment: .leading, spacing: 20){
                        Text("• 1% = 10,000 PPM")
                        Text("• Federal PEL for NH₃ is 50 PPM")
                        Text("• Federal STEL for NH₃ is 35 PPM")
                        Text("• Federal IDLH for NH₃ is 300 PPM")
                        Text("• Hydrostatic Expansion for NH₃ is 100 PSI – 150 PSI per °F of heat exposure")
                        Text("• Liquid NH₃ swelling effect is 20% its original size under standard atmospheric temperatures.")
                        Text("• Liquid NH₃ expansion rate at standard atmospheric pressure is 768:1")
                        Text("• H₂O absorption rate of NH₃ gas is 1,300:1")
                        Text("• 2.5 gallons of water to dilute one pound of ammonia gas")
                        Text("• pH of NH₃ is about 11.6")
                        Text("• Oils can absorb approximately 1% of ammonia gas by volume")
                        Text("• 1 mA is 1/1,000 of an amp")
                        Text("• 1 HP = 2,545 BTU’s of Energy")
                        Text("• Three-Phase kW = ((Amps × Volts × Power Factor × 1.73) / 1,000")
                        Text("• Single-Phase kW = ((Amps × Volts × Power Factor) / 1,000)")
                        Text("• kW = 3,412 BTU’s of Energy per Hour = 28.6% of a Ton")
                        Text("• 1 HP = 0.746 kilowatts = 746 watts")
                        Text("• BHP Single-Phase = {(Volts x Amps x % Efficient x Power Factor) / 746}")
                        Text("• BHP Three-Phase = {(Volts x Amps x % Efficient x Power Factor x 1.73) / 746}")
                        Text("• 200 BTU's / Min = 1 Ton of Refrigeration")
                        Text("• 12,000 BTU's / Hour = 1 Ton of Refrigeration")
                        Text("• 288,000 BTU's / 24 Hours = 1 Ton of Refrigeration")
                        Text("• Volume of a cylinder is = (Length x Radius x Radius x π)")
                        Text("• Volume of a Rectangle/Square = (Length x Width x Height)")
                        Text("• Compression Ratio = (Discharge Pressure in PSIA / Suction Pressure in PSIA)")
                        Text("• NH3 latent heat of boiling is approximately 561 BTU's")
                        Text("• H20 latent heat of boiling is approximately 970 BTU's")
                        Text("• H20 latent heat of freezing is approximately 144 BTU's")
                        Text("• C = {(F - 32) / 1.8}")
                        Text("• F = {(C x 1.8) + 32}")
                        Text("• Sensible Heat Equation: BTU's = {Mass x Specific Heat x (T1 - T2)}")
                        Text("• Latent Heat Equation: BTU's = (Mass x Latent Heat of Freezing)")
                        Text("• Specific Heat (Cp) of liquid H20 is 1.0")
                        Text("• Specific Heat (Cp) of liquid NH3 is 1.12")
                        Text("• Pressure = (Force / Area)")
                        Text("• PSIA = {14.7 - (\"Hg / 2.035)}")
                        Text("• PSIA = (14.7 + PSIG)")
                        Text("• PSIG = (PSIA - 14.7)")
                        Text("• 1 BARa = 14.7 PSIA = 0 PSIG = 0\"Hg")
                        Text("• Flash / Tax Gas % for NH3 = {(TD x 1.12) / 561}")
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14))
                    .foregroundColor(Color(hex: "#454545"))
                    .padding(.bottom, 30)
                    .lineSpacing(10)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                
                Button(action: {dismiss()}) {
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
    }
}

//#Preview {
//    FormulasView(path : .constant(NavigationPath()), headerText: "FormulasView")
//}
