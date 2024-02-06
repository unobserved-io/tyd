//
//  Medication.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/7/23.
//

import Foundation
import SwiftData

@Model
final class Medication: Codable {
    enum CodingKeys: CodingKey {
        case name
        case time
        case dose
    }

    @Attribute(.allowsCloudEncryption) var name: String = ""
    @Attribute(.allowsCloudEncryption) var time: Date = Date.now
    @Attribute(.allowsCloudEncryption) var dose: String = ""
    var day: DayData?

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.time = try container.decode(Date.self, forKey: .time)
        self.dose = try container.decode(String.self, forKey: .dose)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(time, forKey: .time)
        try container.encode(dose, forKey: .dose)
    }

    func setDay(_ dayData: DayData) {
        day = dayData
    }
}
