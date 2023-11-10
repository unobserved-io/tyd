//
//  Medication.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/7/23.
//

import Foundation
import SwiftData

@Model
final class Medication {
    var id: UUID
    var name: String
    var time: Date
    var dose: String

    init() {
        self.id = UUID()
        self.name = ""
        self.time = .now
        self.dose = ""
    }
}
