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
    @Attribute(.allowsCloudEncryption) var periodSymptoms: [String] = []
    @Attribute(.allowsCloudEncryption) var pmsSymptoms: [String] = []
    @Attribute(.allowsCloudEncryption) var medicines: [String]  = ["Aspirin", "Ibuprofen", "Paracetamol", "Acetaminophen"]
    @Attribute(.allowsCloudEncryption) var timerIntervals: [Float] = [
        4.0, // Cup
        4.0, // Pad
        4.0, // Tampon
        4.0  // Underwear
    ]
    @Attribute(.allowsCloudEncryption) var firstDayUsingTyd: Date = Date.now

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
