//
//  MagneticToolView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct MagneticToolView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    let headerText: String
    
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    
    @State private var toggle_status = false
    
    @State private var vibrate_image_name = "vibrate_on"
    @State private var sound_image_name = "volume_on"
    
    @State private var is_clicked_sound_image = false
    @State private var is_clicked_vibrate_image = false
    @State private var is_clicked_activate = false
    
    @State private var show_floating_panel = false
    
    @State private var slider_value: Double = 400
    
    @State private var is_rotate = false
    
    @State private var rotationAngle: Double = 0
    
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
                Spacer().frame(height: Headerbar_Bottom_Padding_Size + 30)
                VStack(spacing: 16) {
                    ZStack() {
                            Image("circle")
                                .resizable()
                                .scaledToFit()
                                .padding(.top, toggle_status ? 9 : 70)
                                .padding(.leading, 60)
                                .padding(.trailing, 60)
                                .padding(.bottom, toggle_status ? 9 : 70)
                                .rotationEffect(.degrees(rotationAngle))
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                        if is_rotate {
                                            withAnimation(.linear(duration: 0.02)) {
                                                rotationAngle += 3
                                                if rotationAngle >= 360 {
                                                    rotationAngle -= 360
                                                }
                                            }
                                        }
                                        else{
                                            withAnimation(.linear(duration: 1)) {
                                                rotationAngle = 360
                                            }
                                        }
                                    }
                                }
                            
                                HStack{
                                    Image(sound_image_name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: is_clicked_sound_image ? 22 : 22, height: is_clicked_sound_image ? 19 : 18)
                                        .onTapGesture {
                                            if sound_image_name == "volume_on" {
                                                sound_image_name = "volume_off"
                                                
                                                is_clicked_sound_image = true
                                            }
                                            else{
                                                sound_image_name = "volume_on"
                                                
                                                is_clicked_sound_image = false
                                            }
                                        }
                                    
                                    Spacer()
                                    
                                    Text("NORMAL EMF detected")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    Image(vibrate_image_name)
                                        .resizable()
                                        .frame(width: is_clicked_vibrate_image ? 22 : 22, height: is_clicked_vibrate_image ? 26 : 18)
                                        .onTapGesture {
                                            if vibrate_image_name == "vibrate_on" {
                                                vibrate_image_name = "vibrate_off"
                                                
                                                is_clicked_vibrate_image = true
                                            }
                                            else{
                                                vibrate_image_name = "vibrate_on"
                                                
                                                is_clicked_vibrate_image = false
                                            }
                                        }
                                    
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                .padding(.top, toggle_status ? 200 : 320)
                                .frame(height: 40)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 6, y: 2)
                    .padding(.horizontal)
                    
                    if toggle_status {
                        VStack{
                            HStack{
                                Spacer()
                                Text("DC: 38 μT")
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            Spacer().frame(height: 4)
                            HStack{
                                Spacer()
                                Text("Threshold: \(Int(slider_value)) μT")
                                    .font(.system(size: 14))
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 6, y: 2)
                        .padding(.horizontal)
                        .onTapGesture{
                            show_floating_panel = true
                        }
                        
                        HStack{
                            Spacer()
                            Image(!is_clicked_activate ? "pause" : "play")
                            
                            Text(!is_clicked_activate ? "Deactivate" : "Activate")
                                .font(.system(size: 16))
                                .onTapGesture {
                                    if is_clicked_activate == true{
                                        is_clicked_activate = false
                                        
                                        if slider_value <= 37{
                                            is_rotate = true
                                        }
                                        else{
                                            is_rotate = false
                                        }
                                    }
                                    else{
                                        is_clicked_activate = true
                                        is_rotate = false
                                    }
                                }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 6, y: 2)
                        .padding(.horizontal)
                    }
                    
                    Text(!toggle_status ? "The indicator rotates when a high eletromagnetic field is deteded" : "The indicator rotates when the detected magnetic field is above the specified threshold")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))
                        .lineSpacing(4)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    
                    HStack{
                        Text("Advanced options")
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        CustomToggle(isOn: $toggle_status, onTrackColor: Color(hex: "#90CFF2"), offTrackColor: .gray.opacity(0.4), onThumbColor: Color(hex: "#2D2F93"), offThumbColor: Color(hex: "#2D2F93"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(25)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .background(Color(hex: "#E5E5E5"))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 6, y: 2)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
            }
            .sheet(isPresented: $show_floating_panel){
                DCThresholdView(is_rotate: $is_rotate, threshold: $slider_value, is_clicked_activate: $is_clicked_activate, onDone: {show_floating_panel = false})
                    .presentationDetents([.fraction(0.3), .fraction(0.3)])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // hide default arrow
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

#Preview {
    MagneticToolView(path : .constant(NavigationPath()), headerText: "MagneticTool")
}
