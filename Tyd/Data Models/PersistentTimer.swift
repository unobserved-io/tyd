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
    var product: PeriodProduct
    var startTime: Date?

    init() {
        self.isRunning = false
        self.product = .tampon
        self.startTime = nil
    }
}
