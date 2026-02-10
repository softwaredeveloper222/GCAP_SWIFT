//
//  api.swift
//  GCAP
//
//  Created by admin on 11/10/25.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    private let baseUrl = "https://gcapcoolworks.com/api/"
    private let imageUrl = "https://gcapcoolworks.com/"
    
    
    func fetchContactInfo() async {
        
    }
    
    //MARK: getValvePositionsData
    func getValvePositionsData() async throws -> [ValvePositionsData] {
        guard let url = URL(string: baseUrl + "get_valve.php") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON Response:\n\(jsonString)")
            }
            
            return try JSONDecoder().decode([ValvePositionsData].self, from: data)
    }
    
    //MARK: getCharts/Graphs Data
    func getChartsGraphsData() async throws -> [ChartsGraphsItem] {
        guard let url = URL(string: baseUrl + "get_charts.php") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON Response:\n\(jsonString)")
            }
            
            return try JSONDecoder().decode([ChartsGraphsItem].self, from: data)
    }
    
    //MARK: getCharts/Graphs Data
    func getIndustryContactsData() async throws -> [IndustryContactsData] {
        guard let url = URL(string: baseUrl + "get_industry.php") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON Response:\n\(jsonString)")
            }
            
            return try JSONDecoder().decode([IndustryContactsData].self, from: data)
    }
    
    //MARK: getIndustryContactsData
    func getAnimationsData() async throws -> [AnimationData] {
        guard let url = URL(string: baseUrl + "get_animations.php") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON Response:\n\(jsonString)")
            }
            
            return try JSONDecoder().decode([AnimationData].self, from: data)
    }
    
    //MARK: geContactUs Data
    func getContactUsData() async throws -> ContactInfo {
        guard let url = URL(string: baseUrl + "get_contact_information.php") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🧾 JSON Response:\n\(jsonString)")
            }
            
            return try JSONDecoder().decode(ContactInfo.self, from: data)
    }
    
    func sendContact(name: String, mail: String, message: String) async throws -> Bool {
        guard let url = URL(string: "https://gcapcoolworks.com/api/contactus.php") else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "name=\(name)&mail=\(mail)&message=\(message)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        request.httpBody = body?.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
        }

        let responseText = String(data: data, encoding: .utf8) ?? ""
        print("Response: \(responseText)")

        return true
    }

}
