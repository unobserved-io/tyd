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
    var name: String
    var time: Date
    var dose: String

    init() {
        self.name = ""
        self.time = .now
        self.dose = ""
    }
}
