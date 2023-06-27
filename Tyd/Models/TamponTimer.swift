//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import Foundation
import SwiftData

@Model
final class TamponTimer {
    var type: String
    var startTime: Date
    var stopTime: Date
    
    init(type: String, startTime: Date) {
        self.type = type
        self.startTime = startTime
    }
    
    func setStopTime(_ stopTime: Date) {
        self.stopTime = stopTime
    }
}

