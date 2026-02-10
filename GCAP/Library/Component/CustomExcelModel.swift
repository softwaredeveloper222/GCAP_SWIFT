
import SwiftUI
import CoreXLSX

import SwiftUI
import CoreXLSX

struct WorkbookData {
    var sheets: [String: [String: String]] = [:]  // sheet -> cellRef -> value
    
    init() {}
    
    init(from url: URL) throws {
        let file = XLSXFile(filepath: url.path)
        let sharedStrings = try file?.parseSharedStrings()
        
        for wsPath in try file?.parseWorksheetPaths() ?? [] {
            let filename = URL(fileURLWithPath: wsPath).lastPathComponent
            let sheetName = filename.replacingOccurrences(of: ".xml", with: "").uppercased()
            
            var cells: [String: String] = [:]
            
            if let worksheet = try file?.parseWorksheet(at: wsPath) {
                for row in worksheet.data?.rows ?? [] {
                    for c in row.cells {
                        let ref = normalizeCellRef(c.reference.description)
                        let text = (sharedStrings != nil ? c.stringValue(sharedStrings!) : nil) ?? c.value
                        if let text, !text.isEmpty {
                            cells[ref] = text
                        }
                    }
                }
            }
            
            sheets[sheetName] = cells
        }
    }
    
    func value(sheet: String, address: String) -> String? {
        let sheetKey = sheet.uppercased()
        let addrKey = normalizeCellRef(address)
        return sheets[sheetKey]?[addrKey]
    }
}

func normalizeCellRef(_ input: String) -> String {
    var letters = "", numbers = ""
    for ch in input.trimmingCharacters(in: .whitespacesAndNewlines) {
        if ch.isLetter { letters.append(ch) }
        else if ch.isNumber { numbers.append(ch) }
    }
    return letters.uppercased() + numbers
}

func colLettersToIndex(_ letters: String) -> Int {
    var result = 0
    for ch in letters.uppercased() {
        result = result * 26 + Int(ch.asciiValue! - 65 + 1)
    }
    return result - 1
}

func indexToColLetters(_ index: Int) -> String {
    var i = index
    var letters = ""
    while i >= 0 {
        let rem = i % 26
        letters = String(UnicodeScalar(rem + 65)!) + letters
        i = (i / 26) - 1
    }
    return letters
}

func parseCellRef(_ ref: String) -> (col: Int, row: Int)? {
    var colStr = "", rowStr = ""
    for ch in ref {
        if ch.isLetter { colStr.append(ch) }
        else if ch.isNumber { rowStr.append(ch) }
    }
    guard let row = Int(rowStr) else { return nil }
    return (col: colLettersToIndex(colStr), row: row - 1)
}

func addressFrom(col: Int, row: Int) -> String {
    "\(indexToColLetters(col))\(row+1)"
}

func expandRange(startRef: String, endRef: String) -> [String]? {
    guard let s = parseCellRef(startRef),
          let e = parseCellRef(endRef) else { return nil }
    var addresses: [String] = []
    for r in min(s.row,e.row)...max(s.row,e.row) {
        for c in min(s.col,e.col)...max(s.col,e.col) {
            addresses.append(addressFrom(col: c, row: r))
        }
    }
    return addresses
}

func indirect(cellRefContainingAddress: String, workbook: WorkbookData, defaultSheet: String = "Sheet1") -> String? {
    guard let parsed = parseCellRef(cellRefContainingAddress) else { return nil }
    let sheet = defaultSheet
    let addr = addressFrom(col: parsed.col, row: parsed.row)
    return workbook.value(sheet: sheet, address: addr)
}

func vlookup(lookupValue: String,
                   sheet: String,
                   startRef: String,
                   endRef: String,
                   colIndex: Int,
                   workbook: WorkbookData) -> String? {
    
    guard let addresses = expandRange(startRef: startRef, endRef: endRef) else {
        return nil
    }

    var rows: [[String]] = []
    if let firstParsed = parseCellRef(addresses[0]) {
        var currentRow = firstParsed.row
        var rowAddrs: [String] = []

        for addr in addresses {
            if let p = parseCellRef(addr) {
                if p.row != currentRow {
                    rows.append(rowAddrs)
                    rowAddrs = []
                    currentRow = p.row
                }
                rowAddrs.append(addr)
            }
        }
        if !rowAddrs.isEmpty { rows.append(rowAddrs) }
    }

    var candidates: [(value: Double, row: [String])] = []

    for r in rows {
        guard let firstAddr = r.first else { continue }
        if let valString = workbook.value(sheet: sheet, address: firstAddr),
           let val = Double(valString) {

            candidates.append((value: val, row: r))
        }
    }

    candidates.sort { $0.value < $1.value }

    var bestMatch: [String]? = nil
    var bestValue = -Double.infinity
    let val = Double(lookupValue) ?? 0
    for c in candidates {
        if c.value <= val, c.value > bestValue {
            bestValue = c.value
            bestMatch = c.row
        }
    }

    guard let matchedRow = bestMatch else { return nil }

    let idx = colIndex - 1
    if idx < matchedRow.count {
        return workbook.value(sheet: sheet, address: matchedRow[idx])
    }

    return nil
}

