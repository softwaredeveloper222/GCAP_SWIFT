//
//  ExcelData.swift
//  GCAP
//
//  Created by admin on 11/14/25.
//

import Foundation
import UIKit
import CoreXLSX

@MainActor
class ExcelDataModel :ObservableObject{
    static let shared = ExcelDataModel()
    
    func formatValue(_ value: String?) -> String? {
        guard let value = value,
              let doubleValue = Double(value) else { return value }
        
        var str = String(format: "%.4f", doubleValue)
        
        while str.contains(".") && (str.hasSuffix("0") || str.hasSuffix(".")) {
            if str.hasSuffix("0") {
                str.removeLast()
            } else if str.hasSuffix(".") {
                str.removeLast()
                break
            }
        }
        
        return str
    }
    
    //MARK: PSIG_DATA_MODEL
    func loadExcel_PSIG() async {
        await Task.detached {
            guard let url = Bundle.main.url(forResource: "PSIG", withExtension: "xlsx") else {
                print("Excel file not found in bundle")
                return
            }
            
            do {
                let file = XLSXFile(filepath: url.path)
                guard let sharedStrings = try file?.parseSharedStrings(),
                      let wsPath = try file?.parseWorksheetPaths().first else {
                    print("Invalid Excel file.")
                    return
                }
                
                let worksheet = try file?.parseWorksheet(at: wsPath)
                var parsedRows: [PSIGExcelRow] = []
                
                for row in worksheet?.data?.rows ?? [] {
                    let cells = row.cells.compactMap { $0.stringValue(sharedStrings) }
                    if cells.count >= 3 {
                        parsedRows.append(PSIGExcelRow(PSIG: cells[0], PISA: cells[1], SVL: cells[2], SVV: cells[3], DL: cells[4], DV: cells[5], TDF: cells[6]))
                    }
                }
                await MainActor.run {
                    PSIG_rows = parsedRows
                }
                
                print("Excel file loaded. Found \(PSIG_rows.count) rows.")
            } catch {
                print("Error reading Excel: \(error)")
            }
        }.value
    }
    
    func PSIG_vlookup(lookupValue: String,
                      tableArray: [PSIGExcelRow],
                      columnIndex: Int) -> String? {
        
        let lookup = lookupValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var bestApproxRow: PSIGExcelRow? = nil
        var bestApproxValue: Double? = nil
        
        let lookupDouble = Double(lookup)
        
        for row in tableArray {
            let rowValueString = row.PSIG.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if rowValueString.caseInsensitiveCompare(lookup) == .orderedSame {
                return formatValue(getPSIGColumnValue(from: row, columnIndex: columnIndex))
            }
            
            if let lv = lookupDouble, let rv = Double(rowValueString), lv == rv {
                return formatValue(getPSIGColumnValue(from: row, columnIndex: columnIndex))
            }

            if let lv = lookupDouble, let rv = Double(rowValueString), rv <= lv {
                if bestApproxValue == nil || rv > bestApproxValue! {
                    bestApproxValue = rv
                    bestApproxRow = row
                }
            }
        }
        
        if let approxRow = bestApproxRow {
            return formatValue(getPSIGColumnValue(from: approxRow, columnIndex: columnIndex))
        }
        
        return nil
    }
    
    func getPSIGColumnValue(from row: PSIGExcelRow, columnIndex: Int) -> String? {
        switch columnIndex {
        case 1: return row.PSIG
        case 2: return row.PISA
        case 3: return row.SVL
        case 4: return row.SVV
        case 5: return row.DL
        case 6: return row.DV
        case 7: return row.TDF
        default: return nil
        }
    }
    
    //MARK: PSIA_DATA_MODEL
    func loadExcel_PSIA() async {
        await Task.detached {
            guard let url = Bundle.main.url(forResource: "PSIA", withExtension: "xlsx") else {
                print("Excel file not found in bundle")
                return
            }
            
            do {
                let file = XLSXFile(filepath: url.path)
                guard let sharedStrings = try file?.parseSharedStrings(),
                      let wsPath = try file?.parseWorksheetPaths().first else {
                    print("Invalid Excel file.")
                    return
                }
                
                let worksheet = try file?.parseWorksheet(at: wsPath)
                var parsedRows: [PSIAExcelRow] = []
                
                for row in worksheet?.data?.rows ?? [] {
                    let cells = row.cells.compactMap { $0.stringValue(sharedStrings) }
                    if cells.count >= 3 {
                        parsedRows.append(PSIAExcelRow(PSIA: cells[0], PISG: cells[1], SVL: cells[2], SVV: cells[3], DL: cells[4], DV: cells[5], TDF: cells[6]))
                    }
                }
                await MainActor.run {
                    PSIA_rows = parsedRows
                }
                
                print("Excel file loaded. Found \(PSIA_rows.count) rows.")
            } catch {
                print("Error reading Excel: \(error)")
            }
        }.value
    }
    
    // PSIA_vlookup in Swift
    func PSIA_vlookup(lookupValue: String,
                              tableArray: [PSIAExcelRow],
                              columnIndex: Int) -> String? {
        
        let lookup = lookupValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var bestApproxRow: PSIAExcelRow? = nil
        var bestApproxValue: Double? = nil
        
        let lookupDouble = Double(lookup)
        
        for row in tableArray {
            let rowValueString = row.PSIA.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if rowValueString.caseInsensitiveCompare(lookup) == .orderedSame {
                return formatValue(getPSIAColumnValue(from: row, columnIndex: columnIndex))
            }
 
            if let lv = lookupDouble, let rv = Double(rowValueString), lv == rv {
                return formatValue(getPSIAColumnValue(from: row, columnIndex: columnIndex))
            }
            
            if let lv = lookupDouble, let rv = Double(rowValueString), rv <= lv {
                if bestApproxValue == nil || rv > bestApproxValue! {
                    bestApproxValue = rv
                    bestApproxRow = row
                }
            }
        }
        
        if let approxRow = bestApproxRow {
            return formatValue(getPSIAColumnValue(from: approxRow, columnIndex: columnIndex))
        }
        
        return nil
    }
    
    // Helper to get column output
    func getPSIAColumnValue(from row: PSIAExcelRow, columnIndex: Int) -> String? {
        switch columnIndex {
        case 1: return row.PSIA
        case 2: return row.PISG
        case 3: return row.SVL
        case 4: return row.SVV
        case 5: return row.DL
        case 6: return row.DV
        case 7: return row.TDF
        default: return nil
        }
    }
    
    //MARK: PISF_DATA_MODEL
    func loadExcel_PSIF() async {
        guard let url = Bundle.main.url(forResource: "PSIF", withExtension: "xlsx") else {
            print("Excel file not found in bundle")
            return
        }
        
        do {
            let file = XLSXFile(filepath: url.path)
            guard let sharedStrings = try file?.parseSharedStrings(),
                  let wsPath = try file?.parseWorksheetPaths().first else {
                print("Invalid Excel file.")
                return
            }
            
            let worksheet = try file?.parseWorksheet(at: wsPath)
            var parsedRows: [PSIFExcelRow] = []
            
            for row in worksheet?.data?.rows ?? [] {
                let cells = row.cells.compactMap { $0.stringValue(sharedStrings) }
                if cells.count >= 3 {
                    parsedRows.append(PSIFExcelRow(TDF: cells[0], PISG: cells[1], PSIA: cells[2], SVL: cells[3], SVV: cells[4], DL: cells[5], DV: cells[6], EB_Hf: cells[7], EB_Hg: cells[8], EB_Sg: cells[9]))
                }
            }
            
            PSIF_rows = parsedRows
            print("Excel file loaded. Found \(PSIF_rows.count) rows.")
        } catch {
            print("Error reading Excel: \(error)")
        }
    }
    
    // MARK: PSIF_vlookup in Swift
    func PSIF_vlookup(lookupValue: String,
                              tableArray: [PSIFExcelRow],
                              columnIndex: Int) -> String? {
        
        let lookup = lookupValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var bestApproxRow: PSIFExcelRow? = nil
        var bestApproxValue: Double? = nil
        
        let lookupDouble = Double(lookup)
        
        for row in tableArray {
            let rowValueString = row.TDF.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if rowValueString.caseInsensitiveCompare(lookup) == .orderedSame {
                return formatValue(getPSIFColumnValue(from: row, columnIndex: columnIndex))
            }
            
            if let lv = lookupDouble, let rv = Double(rowValueString), lv == rv {
                return formatValue(getPSIFColumnValue(from: row, columnIndex: columnIndex))
            }
            
            if let lv = lookupDouble, let rv = Double(rowValueString), rv <= lv {
                if bestApproxValue == nil || rv > bestApproxValue! {
                    bestApproxValue = rv
                    bestApproxRow = row
                }
            }
        }
        
        if let approxRow = bestApproxRow {
            return formatValue(getPSIFColumnValue(from: approxRow, columnIndex: columnIndex))
        }
        
        return nil
    }
    
    func getPSIFColumnValue(from row: PSIFExcelRow, columnIndex: Int) -> String? {
        switch columnIndex {
        case 1: return row.TDF
        case 2: return row.PISG
        case 3: return row.PSIA
        case 4: return row.SVL
        case 5: return row.SVV
        case 6: return row.DL
        case 7: return row.DV
        case 8: return row.EB_Hf
        case 9: return row.EB_Hg
        case 10: return row.EB_Sg
        default: return nil
        }
    }
    
    
    func loadExcel_Superheat() async {
        await Task.detached {
            guard let url = Bundle.main.url(forResource: "Superheat", withExtension: "xlsx") else {
                print("Excel file not found in bundle")
                return
            }
            
            do {
                let file = XLSXFile(filepath: url.path)
                guard let sharedStrings = try file?.parseSharedStrings(),
                      let wsPath = try file?.parseWorksheetPaths().first else {
                    print("Invalid Excel file.")
                    return
                }
                
                let worksheet = try file?.parseWorksheet(at: wsPath)
                var parsedRows: [SuperheatExcelRow] = []
                
                for row in worksheet?.data?.rows ?? [] {
                    let cells = row.cells.compactMap { $0.stringValue(sharedStrings) }
                    if cells.count >= 2 {
                        parsedRows.append(SuperheatExcelRow(PSIG: cells[0], Temp: cells[1]))
                    }
                }
                await MainActor.run {
                    Superheat_rows = parsedRows
                }
                
                print("Excel file loaded. Found \(Superheat_rows.count) rows.")
            } catch {
                print("Error reading Excel: \(error)")
            }
        }
    }
    
    func Superheat_vlookup(lookupValue: String,
                      tableArray: [SuperheatExcelRow],
                      columnIndex: Int) -> String? {
        
        let lookup = lookupValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var bestApproxRow: SuperheatExcelRow? = nil
        var bestApproxValue: Double? = nil
        
        let lookupDouble = Double(lookup)
        
        for row in tableArray {
            let rowValueString = row.PSIG.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if rowValueString.caseInsensitiveCompare(lookup) == .orderedSame {
                return formatValue(getSuperheatColumnValue(from: row, columnIndex: columnIndex))
            }
            
            if let lv = lookupDouble, let rv = Double(rowValueString), lv == rv {
                return formatValue(getSuperheatColumnValue(from: row, columnIndex: columnIndex))
            }
            
            if let lv = lookupDouble, let rv = Double(rowValueString), rv <= lv {
                if bestApproxValue == nil || rv > bestApproxValue! {
                    bestApproxValue = rv
                    bestApproxRow = row
                }
            }
        }
        
        if let approxRow = bestApproxRow {
            return formatValue(getSuperheatColumnValue(from: approxRow, columnIndex: columnIndex))
        }
        
        return nil
    }
    
    func getSuperheatColumnValue(from row: SuperheatExcelRow, columnIndex: Int) -> String? {
        switch columnIndex {
        case 1: return row.PSIG
        case 2: return row.Temp
        default: return nil
        }
    }
    
    func loadPressureExcel() async {
        await Task.detached {
            guard let url = Bundle.main.url(forResource: "PE", withExtension: "xlsx") else { return }

            do {
                let workbook = try WorkbookData(from: url)

                // Store value back to MainActor
                await MainActor.run {
                    wb = workbook
                }
                
            } catch {
                print("Error: \(error)")
            }
        }.value
    }

}
