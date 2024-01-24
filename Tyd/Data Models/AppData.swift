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
    var periodSymptoms: [String] = []
    var pmsSymptoms: [String] = []
    var medicines: [String]  = ["Aspirin", "Ibuprofen", "Paracetamol", "Acetaminophen"]
    var timerIntervals: [Float] = [
        4.0, // Cup
        4.0, // Pad
        4.0, // Tampon
        4.0  // Underwear
    ]
    var firstDayUsingTyd: Date = Date.now

    init() {}
    
    func getInterval(for product: PeriodProduct) -> Float {
        switch product {
        case .cup: return timerIntervals[0]
        case .pad: return timerIntervals[1]
        case .tampon: return timerIntervals[2]
        case .underwear: return timerIntervals[3]
        }
    }
}
