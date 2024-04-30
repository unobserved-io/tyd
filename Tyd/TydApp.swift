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
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    @State private var passStatusModel = PassStatusModel()
    @State private var calendarDateChanger = CalendarDateChanger()

    var body: some Scene {
        WindowGroup {
            LoadingView()
                .accentColor(Color(hex: tydAccentColor) ?? .accent)
                .environment(passStatusModel)
                .environment(calendarDateChanger)
        }
        .modelContainer(for: [
            AppData.self,
            DayData.self,
            Medication.self,
            TimedEvent.self
        ])
    }
    
    init() {
        // Reset for testing
        // try? Tips.resetDatastore()
        try? Tips.configure()
    }
}
