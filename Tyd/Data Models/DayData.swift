//
//  Item.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import Foundation
import SwiftData

@Model
final class DayData: Codable {
    enum CodingKeys: CodingKey {
        case day
        case period
        case pms
        case bleeding
        case pain
        case periodSymptoms
        case pmsSymptoms
        case medication
        case notes
        case timerData
    }

    var day: String = ""
    var period: Bool = false
    var pms: Bool = false
    var bleeding: Double = 0.0
    var pain: Double = 0.0
    var periodSymptoms: Set<String> = []
    var pmsSymptoms: Set<String> = []
    @Relationship(inverse:\Medication.day) var medication: [Medication]? = []
    var notes: String = ""
    @Relationship(inverse:\TimedEvent.day) var timerData: [TimedEvent]? = []

    init(day: String) {
        self.day = day
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try container.decode(String.self, forKey: .day)
        self.period = try container.decode(Bool.self, forKey: .period)
        self.pms = try container.decode(Bool.self, forKey: .pms)
        self.bleeding = try container.decode(Double.self, forKey: .bleeding)
        self.pain = try container.decode(Double.self, forKey: .pain)
        self.periodSymptoms = try container.decode(Set<String>.self, forKey: .periodSymptoms)
        self.pmsSymptoms = try container.decode(Set<String>.self, forKey: .periodSymptoms)
        self.medication = try container.decode([Medication].self, forKey: .medication)
        self.notes = try container.decode(String.self, forKey: .notes)
        self.timerData = try container.decode([TimedEvent].self, forKey: .timerData)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(day, forKey: .day)
        try container.encode(period, forKey: .period)
        try container.encode(pms, forKey: .pms)
        try container.encode(bleeding, forKey: .bleeding)
        try container.encode(pain, forKey: .pain)
        try container.encode(periodSymptoms, forKey: .periodSymptoms)
        try container.encode(pmsSymptoms, forKey: .pmsSymptoms)
        try container.encode(medication, forKey: .medication)
        try container.encode(notes, forKey: .notes)
        try container.encode(timerData, forKey: .timerData)
    }
}
