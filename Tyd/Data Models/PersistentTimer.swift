//
//  Timer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/12/23.
//

import Foundation
import SwiftData

@Model
final class PersistentTimer {
    var isRunning: Bool
    var formatted: String
    var timedEvent: TimedEvent?

    init() {
        self.isRunning = false
        self.formatted = "00:00:00"
        self.timedEvent = nil
    }
}
