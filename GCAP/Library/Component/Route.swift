//
//  Route.swift
//  GCAP
//
//  Created by admin on 11/6/25.
//

import Foundation


enum AppRoute: String, Hashable {
    case calculators = "Calculators"
    case valve_positions = "Valve Positions"
    case formulas = "Formulas"
    case charts_graphs = "Charts/Graphs"
    case animations = "Animations"
    case magnetic_tool = "Magnetic Tool"
    case industry_contacts = "Industry Contacts"
    case contact_us = "Contact Us"
}

enum CalculatorsRoute: String, Hashable {
    case saturation_PSIG = "Saturation Calculator (Input: PSIG)"
    case saturation_PSIA = "Saturation Calculator (Input: PSIA)"
    case saturation_fahrenheit = "Saturation Calculator (Input: °F)"
    case pressure_enthalpy = "Pressure Enthalpy Calculator"
    case release = "Release Calculator"
    case superheat_subcooling = "Superheat-Subcooling Calculator"
}

enum ContactRoute: Hashable {
    case contact_detail(industryContact: IndustryContactsData?, headerText: String)
}
