//
//  Extensions.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/9/23.
//

import SwiftUI

extension PresentationDetent {
    static let medicationInput = Self.fraction(0.3)
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
