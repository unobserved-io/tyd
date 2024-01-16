//
//  TydApp.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftData
import SwiftUI
import TipKit

@main
struct TydApp: App {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    @State private var timerHelper = TimerHelper()
    @State private var stats = Stats()
    @State private var passStatusModel = PassStatusModel()

    var body: some Scene {
        WindowGroup {
            LoadingView()
                .accentColor(Color(hex: tydAccentColor) ?? .accent)
                .environment(timerHelper)
                .environment(stats)
                .environment(passStatusModel)
        }
        .modelContainer(for: [
            AppData.self,
            DayData.self,
            Medication.self,
            TimedEvent.self,
            PersistentTimer.self
        ])
    }
    
    init() {
        // Reset for testing
        // try? Tips.resetDatastore()
        try? Tips.configure()
    }
}
