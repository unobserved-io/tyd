//
//  Item.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import Foundation
import SwiftData

@Model
final class Day {
    var day: String
    var period: Bool
    var pms: Bool
    var bleeding: Int
    var pain: Int
    var periodSymptoms: [String]
    var periodMedsTaken: [[String]]
    var periodNotes: String
    var pmsSymptoms: [String]
    var pmsMedsTaken: [[String]]
    var pmsNotes: String
    var timerData: [[TamponTimer]]
    
    
    init(day: String) {
        self.day = day
    }
}
