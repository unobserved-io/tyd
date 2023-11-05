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
    var date: Date
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
    var timerData: [TamponTimer]
    
    init(day: String) {
        self.day = day
        self.date = dateFormatter.date(from: day) ?? Date.now
        self.period = false
        self.pms = false
        self.bleeding = 0
        self.pain = 0
        self.periodSymptoms = []
        self.periodMedsTaken = [[]]
        self.periodNotes = ""
        self.pmsSymptoms = []
        self.pmsMedsTaken = [[]]
        self.pmsNotes = ""
        self.timerData = []
    }
}
