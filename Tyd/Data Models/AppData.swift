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
    var medicines: [String]
    var timerIntervals: [String: Float]

    init() {
        self.periodSymptoms = []
        self.pmsSymptoms = []
        self.medicines = ["Aspirin", "Ibuprofen", "Paracetamol", "Acetaminophen"]
        self.timerIntervals = [
            "Tampon": 4.0,
            "Pad": 4.0,
            "Cup": 4.0,
            "Underwear": 4.0
        ]
    }
}
