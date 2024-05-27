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
    // TODO: Remove pass model when certain no one is subscribed
    @State private var passStatusModel = PassStatusModel()
    @State private var calendarDateChanger = CalendarDateChanger()
    @ObservedObject var storeModel = StoreModel.shared

    var body: some Scene {
        WindowGroup {
            LoadingView()
                .accentColor(Color(hex: tydAccentColor) ?? .accent)
                .environment(passStatusModel)
                .environment(calendarDateChanger)
                .onAppear {
                    Task {
                        try await storeModel.fetchProducts()
                    }
                }
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
