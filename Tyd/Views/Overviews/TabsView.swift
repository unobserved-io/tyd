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
                .onAppear {
                    let sortedDays = dayData.sorted(by: {
                        dateFormatter.date(from: $0.day) ?? .now > dateFormatter.date(from: $1.day) ?? .now
                    })
                    stats.getLastPeriod(from: sortedDays)
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
