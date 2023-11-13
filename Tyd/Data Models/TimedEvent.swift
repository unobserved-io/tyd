//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import Foundation
import SwiftData

@Model
final class TimedEvent {
    var product: Product
    var startTime: Date
    var stopTime: Date
    var formattedTime: String
    
    init(product: Product, startTime: Date, stopTime: Date) {
        self.product = product
        self.startTime = startTime
        self.stopTime = stopTime
        self.formattedTime = "00:00"
    }
    
    func setStopTime(_ stopTime: Date) {
        self.stopTime = stopTime
    }
}

