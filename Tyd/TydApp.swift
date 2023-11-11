//
//  TydApp.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftData
import SwiftUI

@main
struct TydApp: App {
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .accentColor(Color(hex: tydAccentColor) ?? .accent)
        }
        .modelContainer(for: [
            AppData.self,
            Day.self,
            Medication.self,
            TamponTimer.self
        ])
    }
}
