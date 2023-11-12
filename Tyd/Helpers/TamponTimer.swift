//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/28/23.
//

import SwiftUI

// TODO: Delete this file if TamponTimer model works

@Observable
class TamponTimer {
    var isRunning: Bool = false
    var formatted = "00:00:00"
    @ObservationIgnored var timedEvent: TimedEvent? = nil
    
    func start() {
        isRunning = true
    }
}
