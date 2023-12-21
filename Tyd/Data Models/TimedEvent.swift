//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import Foundation
import SwiftData

@Model
final class TimedEvent: Codable {
    enum CodingKeys: CodingKey {
        case product
        case startTime
        case stopTime
        case formattedTime
    }

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

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.product = try container.decode(Product.self, forKey: .product)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.stopTime = try container.decode(Date.self, forKey: .stopTime)
        self.formattedTime = try container.decode(String.self, forKey: .formattedTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(product, forKey: .product)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(stopTime, forKey: .stopTime)
        try container.encode(formattedTime, forKey: .formattedTime)
    }

    func setStopTime(_ stopTime: Date) {
        self.stopTime = stopTime
    }
}
