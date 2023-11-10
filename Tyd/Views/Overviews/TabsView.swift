//
//  MainView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftUI

struct TabsView: View {
    @Environment(\.modelContext) private var modelContext

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
//
//            TimerView()
//                .tabItem {
//                    Image(systemName: "timer")
//                }
//
//            StatsView()
//                .tabItem {
//                    Image(systemName: "chart.bar")
//                }
//
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
