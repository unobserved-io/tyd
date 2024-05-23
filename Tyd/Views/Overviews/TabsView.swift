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

    @Query private var appData: [AppData]
    @Query private var dayData: [DayData]
    
    @AppStorage("ptProduct") private var ptProduct: PeriodProduct = .tampon

    @State var selectedTab = "home"
    
    private let willBecomeActive = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
    
    private var stats = Stats.shared
    private var timerHelper = TimerHelper.shared

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag("home")
                .onAppear {
                    stats.updateAllStats(from: dayData)
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag("calendar")

            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag("timer")

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag("stats")
                .onAppear {
                    stats.updateAllStats(from: dayData)
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag("settings")
        }
        .onOpenURL { url in
            guard url.scheme == "tyd" else {
                return
            }
            if url.absoluteString == "tyd://timerView" {
                selectedTab = "timer"
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .inactive {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onAppear {
            // Resume timer
            timerHelper.checkForResume(interval: appData.first?.getInterval(
                for: ptProduct
            ) ?? 4.0)
        }
        .onReceive(willBecomeActive) { _ in
            // Resume timer
            timerHelper.checkForResume(interval: appData.first?.getInterval(
                for: ptProduct
            ) ?? 4.0)
        }
    }
}

#Preview {
    TabsView()
}
