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
    @Attribute(.allowsCloudEncryption) var isRunning: Bool = false
    @Attribute(.allowsCloudEncryption) var product: PeriodProduct = PeriodProduct.tampon
    @Attribute(.allowsCloudEncryption) var startTime: Date?

    init() {}
}
