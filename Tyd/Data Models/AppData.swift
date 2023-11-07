//
//  AppData.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/6/23.
//

import Foundation
import SwiftData

@Model
final class AppData {
    var periodSymptoms: [String]
    var pmsSymptoms: [String]
    var medication: [String]

    init() {
        self.periodSymptoms = []
        self.pmsSymptoms = []
        self.medication = ["Aspirin", "Ibuprofen", "Paracetamol", "Acetaminophen"]
    }
}
