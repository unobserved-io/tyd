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
    @State var selectedTab = "home"

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house")
                }
                .tag("home")
                .onAppear {
                    stats.updateAllStats(from: dayData)
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                }
                .tag("calendar")

            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                }
                .tag("timer")

            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                }
                .tag("stats")
                .onAppear {
                    stats.updateAllStats(from: dayData)
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
                .tag("settings")
        }
        .onOpenURL { url in
            guard url.scheme == "tyd" else { return }
            if url.absoluteString == "tyd://timerView" {
                selectedTab = "timer"
            }
        }
    }
}

#Preview {
    TabsView()
}
