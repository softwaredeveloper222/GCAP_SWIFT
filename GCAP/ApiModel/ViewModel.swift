//
//  ViewModel.swift
//  GCAP
//
//  Created by admin on 11/10/25.
//

import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    @Published var animation: [AnimationData] = []
    @Published var valvePositionsData: [ValvePositionsData] = []
    @Published var chartsGraphsData: [ChartsGraphsItem] = []
    @Published var industryContactData: [IndustryContactsData] = []
    @Published var contactInfoData: ContactInfo? = nil
    
    @Published var errorMessage: String?
    
    func GetAnimationsData() async {
        do{
            animation = try await ApiService.shared.getAnimationsData()
        } catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func GetValvePositionsData() async {
        do{
            valvePositionsData = try await ApiService.shared.getValvePositionsData()
        } catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func GetChartsGraphsData() async {
        do{
            chartsGraphsData = try await ApiService.shared.getChartsGraphsData()
        } catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func GetIndustryContactData() async {
        do{
            industryContactData = try await ApiService.shared.getIndustryContactsData()
        } catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func GetContactUsData() async {
        do{
            contactInfoData = try await ApiService.shared.getContactUsData()
        } catch{
            errorMessage = error.localizedDescription
        }
    }
    func sendContactData(name: String, mail: String, message: String) async -> Bool {
        do{
           let flag = try await ApiService.shared.sendContact(name: name, mail: mail, message: message)
            return flag
        } catch{
            errorMessage = error.localizedDescription
            return false
        }
    }
}
