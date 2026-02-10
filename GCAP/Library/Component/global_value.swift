//
//  global_value.swift
//  GCAP
//
//  Created by admin on 11/9/25.
//

import SwiftUI


var Headerbar_Bottom_Padding_Size: Double = UIDevice.current.userInterfaceIdiom == .pad ? 260 : 220

var GoHomeButtonFontSize: Double = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12

var BASE_URL = "https://gcapcoolworks.com/api/"
var IMAGE_URL = "https://gcapcoolworks.com/"

var PSIG_rows: [PSIGExcelRow] = []
var PSIA_rows: [PSIAExcelRow] = []
var PSIF_rows: [PSIFExcelRow] = []

var wb: WorkbookData = WorkbookData()

var Superheat_rows: [SuperheatExcelRow] = []

var video_url = ""


