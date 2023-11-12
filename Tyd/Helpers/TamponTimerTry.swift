//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/28/23.
//

import SwiftUI

// TODO: Delete this file if TamponTimer model works

@Observable
class TamponTimerTry {
    var isRunning: Bool = false
    var formatted = "00:00:00"
    @ObservationIgnored var timedEvent: TimedEvent? = nil
    
    init() {
        self.isRunning = false
        self.formatted = "00:00:00"
        self.timedEvent = nil
    }
}
