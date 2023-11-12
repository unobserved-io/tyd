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
    @Environment(\.modelContext) private var modelContext
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    @State private var tamponTimer = TamponTimer()

    var body: some Scene {
        WindowGroup {
            LoadingView()
                .accentColor(Color(hex: tydAccentColor) ?? .accent)
                .environment(tamponTimer)
        }
        .modelContainer(for: [
            AppData.self,
            Day.self,
            Medication.self,
            TimedEvent.self,
            PersistentTimer.self
        ])
    }
}
