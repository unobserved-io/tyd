//
//  MainView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftData
import SwiftUI

struct TabsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Stats.self) private var stats
    @Query private var dayData: [DayData]

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                }

            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                }

            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                }
                .onAppear {
                    stats.updateAllStats(from: dayData)
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}

#Preview {
    TabsView()
}
