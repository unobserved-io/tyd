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
    var isRunning: Bool = false
    var product: PeriodProduct = PeriodProduct.tampon
    var startTime: Date?

    init() {}
}
