//
//  ContentView.swift
//  GCAP
//
//  Created by admin on 11/5/25.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let router: AppRoute
}


struct ContentView: View {
    let menuItems: [MenuItem] = [
        MenuItem(title: "Calculators", icon: "ic_calculators", router: AppRoute.calculators),
        MenuItem(title: "Valve Positions", icon: "ic_valves", router: AppRoute.valve_positions),
        MenuItem(title: "Formulas", icon: "ic_formulas", router: AppRoute.formulas),
        MenuItem(title: "Charts/Graphs", icon: "ic_charts", router: AppRoute.charts_graphs),
        MenuItem(title: "Animations", icon: "ic_animations", router: AppRoute.animations),
        MenuItem(title: "Magnetic Tool", icon: "ic_magnet", router: AppRoute.magnetic_tool),
        MenuItem(title: "Industry Contacts", icon: "ic_partners", router: AppRoute.industry_contacts),
        MenuItem(title: "Safety Days", icon: "ic_safety_days", router: AppRoute.safety_days),
        MenuItem(title: "Contact Us", icon: "ic_contact", router: AppRoute.contact_us)
        ]
    
    @State private var path = NavigationPath()
    
    @State private var headerText = " "
    /// Set when opening Safety Days from a push tap (CMS content id).
    @State private var safetyDaysContentId: String?
    @ObservedObject private var safetyDaysService = SafetyDaysNotificationService.shared
    @ObservedObject private var pushNavigation = PushNavigationStore.shared
            
    var body: some View {
        NavigationStack(path: $path){
            ZStack {
                ZStack() {
                    HeaderView(headerText: headerText)
                    VStack{
                        Spacer().frame(height: Headerbar_Bottom_Padding_Size - 30)
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(menuItems) { item in
                                    HStack {
                                        Image(item.icon)
                                            .resizable()
                                            .frame(width: 78, height: 78)
                                        
                                        Text(item.title)
                                            .foregroundColor(.black)
                                            .padding(.leading, 8)
                                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 22 : 18, weight: .semibold))
                                        
                                        Spacer()

                                        if item.router == .safety_days && safetyDaysService.hasUnreadUpdate {
                                            Text("New")
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 3)
                                                .background(Color.red)
                                                .cornerRadius(8)
                                        }
                                        
                                        Image("right_arrow")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16, height: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
                                    }
                                    .padding(.top, 12)
                                    .padding(.bottom, 12)
                                    .padding(.leading, 10)
                                    .padding(.trailing, 15)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 1, y: 2)
                                    .onTapGesture{
                                        path.append(item.router)
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, 36)
                        }
                        .refreshable {
                            await safetyDaysService.refresh()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .task {
                await safetyDaysService.refresh()
            }
            .onAppear {
                openPendingPushRouteIfNeeded()
            }
            .onChange(of: pushNavigation.pendingRoute) { _, _ in
                openPendingPushRouteIfNeeded()
            }
            .navigationDestination(for: AppRoute.self){ route in
                switch route {
                case .calculators:
                    CalculatorsView(path: $path, headerText: "\(AppRoute.calculators.rawValue)")
                case .valve_positions:
                    ValvePositions(path: $path, headerText: "\(AppRoute.valve_positions.rawValue)")
                case .formulas:
                    FormulasView(path: $path, headerText: "\(AppRoute.formulas.rawValue)")
                case .charts_graphs:
                    ChartsGraphsView(path: $path, headerText: "\(AppRoute.charts_graphs.rawValue)")
                case .animations:
                    AnimationsView(path: $path, headerText: "\(AppRoute.animations.rawValue)")
                case .magnetic_tool:
                    MagneticToolView(path: $path, headerText: "\(AppRoute.magnetic_tool.rawValue)")
                case .industry_contacts:
                    IndustryContactsView(path: $path, headerText: "\(AppRoute.industry_contacts.rawValue)")
                case .safety_days:
                    SafetyDaysView(
                        path: $path,
                        headerText: "\(AppRoute.safety_days.rawValue)",
                        contentId: safetyDaysContentId
                    )
                    .onDisappear {
                        safetyDaysContentId = nil
                    }
                case .contact_us:
                    ContactUsView(path: $path, headerText: "\(AppRoute.contact_us.rawValue)")
                    
                }
            }
            .navigationDestination(for: ContactRoute.self){ route in
                switch route {
                case .contact_detail(let industryContactItem, let headerText):
                    ContactsChildView(path: $path, industryItemData: (industryContactItem)!, headerText: headerText)
                }
            }
        }
    }

    private func openPendingPushRouteIfNeeded() {
        guard let pending = pushNavigation.consumePendingRoute() else { return }
        if pending.route == .safety_days {
            safetyDaysContentId = pending.contentId
        }
        // Match Android CLEAR_TOP: open Safety Days from root so push content is shown.
        path = NavigationPath()
        path.append(pending.route)
    }

}

extension Color {
    init(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned = cleaned.replacingOccurrences(of: "#", with: "")
        
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    ContentView()
}
