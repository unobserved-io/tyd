//
//  MainView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftData
import SwiftUI
import WidgetKit

struct TabsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase

    @Query private var dayData: [DayData]

    private var stats = Stats.shared
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
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .inactive {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}

#Preview {
    TabsView()
}
