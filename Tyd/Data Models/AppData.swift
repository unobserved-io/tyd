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
    var timerIntervals: [Product: Float]

    init() {
        self.periodSymptoms = []
        self.pmsSymptoms = []
        self.medicines = ["Aspirin", "Ibuprofen", "Paracetamol", "Acetaminophen"]
        self.timerIntervals = [
            .tampon: 4.0,
            .pad: 4.0,
            .cup: 4.0,
            .underwear: 4.0
        ]
    }
}
