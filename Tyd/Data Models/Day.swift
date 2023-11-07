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
    @Attribute(.unique) var day: String
    var period: Bool
    var pms: Bool
    var bleeding: Double
    var pain: Double
    var periodSymptoms: Set<String>
    var pmsSymptoms: Set<String>
    var medication: [Medication]
    var notes: String
    var timerData: [TamponTimer]

    init(day: String) {
        self.day = day
        self.period = false
        self.pms = false
        self.bleeding = 0.0
        self.pain = 0.0
        self.periodSymptoms = []
        self.pmsSymptoms = []
        self.medication = []
        self.notes = ""
        self.timerData = []
    }
}
