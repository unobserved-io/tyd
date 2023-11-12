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
    var stopTime: Date?
    
    init(product: Product, startTime: Date) {
        self.product = product
        self.startTime = startTime
        self.stopTime = nil
    }
    
    func setStopTime(_ stopTime: Date) {
        self.stopTime = stopTime
    }
}

