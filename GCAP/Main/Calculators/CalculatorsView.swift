//
//  CalculatorsView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct CalCulatorsMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let router: CalculatorsRoute
}

struct CalculatorsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
        
    let menuItems: [CalCulatorsMenuItem] = [
        CalCulatorsMenuItem(title: "Saturation Calculator (Input: PSIG)", icon: "", router: CalculatorsRoute.saturation_PSIG),
        CalCulatorsMenuItem(title: "Saturation Calculator (Input: PSIA)", icon: "", router: CalculatorsRoute.saturation_PSIA),
        CalCulatorsMenuItem(title: "Saturation Calculator (Input: °F)", icon: "", router: CalculatorsRoute.saturation_fahrenheit),
        CalCulatorsMenuItem(title: "Pressure Enthalpy Calculator", icon: "", router: CalculatorsRoute.pressure_enthalpy),
        CalCulatorsMenuItem(title: "Release Calculator", icon: "", router: CalculatorsRoute.release),
        CalCulatorsMenuItem(title: "Superheat-Subcooling Calculator", icon: "", router: CalculatorsRoute.superheat_subcooling)
    ]
   
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
        ZStack(){
            HeaderView(headerText: headerText)
            
            VStack{
                Spacer().frame(height: Headerbar_Bottom_Padding_Size)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(menuItems) { item in
                            HStack {
                                Spacer().frame(width:0, height: 36,)
                                
                                Text(item.title)
                                    .foregroundColor(.black)
                                    .padding(.leading, 8)
                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, weight: .semibold))
                                
                                Spacer()
                                
                                Image("right_arrow")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, height: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
                            }
                            .padding(.top, 30)
                            .padding(.bottom, 30)
                            .padding(.trailing, 15)
                            .padding(.leading, 10)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 1, y: 2)
                            .onTapGesture{
                                path.append(item.router)
                            }
                        }
                    }
                    .padding()
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
                    path.removeLast()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: GoHomeButtonFontSize, weight: .heavy))
                    }
                    .foregroundColor(Color.white)
                }
            }
            
        }
        .navigationDestination(for: CalculatorsRoute.self){ route in
            switch route {
            case .saturation_PSIG:
                PSIGView(path: $path, headerText: "Saturation Calculator")
            case .saturation_PSIA:
                PSIAView(path: $path, headerText: "Saturation Calculator")
            case .saturation_fahrenheit:
                FahrenheitView(path: $path, headerText: "Saturation Calculator")
            case .pressure_enthalpy:
                PressureView(path: $path, headerText: "\(CalculatorsRoute.pressure_enthalpy.rawValue)")
            case .release:
                ReleaseView(path: $path, headerText: "\(CalculatorsRoute.release.rawValue)")
            case .superheat_subcooling:
                SuperheatView(path: $path, headerText: "Superheat-Subcooling")
            }
        }
    }
    
}

#Preview {
    CalculatorsView(path : .constant(NavigationPath()), headerText: "Calculators")
}
