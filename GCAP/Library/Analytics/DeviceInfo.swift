//
//  DeviceInfo.swift
//  GCAP
//

import Foundation
import UIKit

struct DeviceInfo {
    let manufacturer: String
    let model: String
    let brand: String
    let osVersion: String

    static func current() -> DeviceInfo {
        DeviceInfo(
            manufacturer: "Apple",
            model: UIDevice.current.model,
            brand: "Apple",
            osVersion: UIDevice.current.systemVersion
        )
    }
}
