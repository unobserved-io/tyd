//
//  ClickedMedication.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/7/23.
//

import Foundation

class ClickedMedication: ObservableObject {
    @Published var medication: Medication?

    init(_ medication: Medication?) {
        self.medication = medication
    }
}
