//
//  DataModels.swift
//  GCAP
//
//  Created by admin on 11/10/25.
//

import Foundation
import SwiftUI

struct AnimationData: Identifiable, Codable, Equatable {
    var id: String = ""
    
    var category_id: String?
    var sub_category_id: String?
    var name: String?
    var image: String?
    var etc: String?
}

struct ValvePositionsData: Identifiable, Codable {
    let id: String
    let categoryID: String
    let name: String
    let image: String
    let list: [ValveSubItem]

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case name
        case image
        case list
    }
}

// MARK: - Sub Item Model
struct ValveSubItem: Identifiable, Codable {
    let id: String
    let categoryID: String
    let subCategoryID: String
    let name: String
    let image: String
    let etc: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case name
        case image
        case etc
    }
}

//MARK: Charts/Graphs

struct ChartsGraphsItem: Identifiable, Codable {
    let id: String
    let categoryID: String
    let subCategoryID: String
    let name: String
    let image: String
    let etc: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case name
        case image
        case etc
    }
}

struct IndustryContactsData: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let categoryID: String
    let subCategoryID: String
    let name: String
    let image: String
    let contactPerson: String
    let phone: String
    let email: String
    let website: String
    let address: String
    let about: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case name
        case image
        case contactPerson = "cperson"
        case phone
        case email
        case website
        case address
        case about
    }
}

struct ContactInfo: Identifiable, Codable {
    let id: String
    let email: String
    let phone: String
    let address: String
    let website: String
}

//MARK: Excel model

struct PSIGExcelRow {
    let PSIG: String
    let PISA: String
    let SVL: String
    let SVV: String
    let DL: String
    let DV: String
    let TDF: String
}

struct PSIAExcelRow {
    let PSIA: String
    let PISG: String
    let SVL: String
    let SVV: String
    let DL: String
    let DV: String
    let TDF: String
}

struct PSIFExcelRow {
    let TDF: String
    let PISG: String
    let PSIA: String
    let SVL: String
    let SVV: String
    let DL: String
    let DV: String
    let EB_Hf: String
    let EB_Hg: String
    let EB_Sg: String
}

struct SuperheatExcelRow {
    let PSIG: String
    let Temp: String
}

// Data model for refrigeration parameters
struct RefrigerationParameter: Identifiable {
    let id = UUID()
    let parameter: String
    let value: String
}

// Data model for thermodynamic points
struct ThermodynamicPoint: Identifiable {
    let id = UUID()
    let point: String
    let temperatureF: Double
    let psia: Double
    let psig: Double
    let enthalpy: Double
    let entropy: Double?
    let rowColor: RowColor
    
    enum RowColor {
        case lightBlue
        case orange
        case yellow
        case mediumBlue
        
        var mainColor: Color {
            switch self {
            case .lightBlue:
                return Color(hex: "#00CCFF")// Light blue
            case .orange:
                return Color(hex: "#FF9900") // Orange
            case .yellow:
                return Color(hex: "#FFCC00") // Yellow
            case .mediumBlue:
                return Color(hex: "#00FFFF")
            }
        }
        
        var entropyColor: Color {
            switch self {
            case .lightBlue:
                return Color(hex: "#005C73") // Darker teal-blue for entropy
            case .orange:
                return Color(hex: "#FF9900") // Orange (same as main)
            case .yellow:
                return Color(hex: "#FFCC00") // Yellow (same as main)
            case .mediumBlue:
                return Color(hex: "#00FFFF")
            }
        }
    }
}

// Crosshatch pattern shape for shaded cells
struct CrosshatchPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 3
        
        // Diagonal lines from top-left to bottom-right
        var x: CGFloat = -rect.height
        while x < rect.width + rect.height {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x + rect.height, y: rect.height))
            x += spacing
        }
        
        // Diagonal lines from top-right to bottom-left
        x = rect.width + rect.height
        while x > -rect.height {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x - rect.height, y: rect.height))
            x -= spacing
        }
        
        return path
    }
}

struct ContactModel: Codable, Equatable {
    let name: String
    let email: String
    let message: String
}
