//
//  MainView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftUI

struct TabsView: View {
//    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
//                    Label(String(localized: "Home"), systemImage: "house")
                    Image(systemName: "house")
                }

            CalendarView()
                .tabItem {
//                    Label(String(localized: "Calendar"), systemImage: "calendar")
                    Image(systemName: "calendar")
                }

            HomeView()
                .tabItem {
//                    Label(String(localized: "Timer"), systemImage: "timer")
                    Image(systemName: "timer")
                }

            HomeView()
                .tabItem {
//                    Label(String(localized: "Stats"), systemImage: "chart.bar")
                    Image(systemName: "chart.bar")
                }

            HomeView()
                .tabItem {
//                    Label(String(localized: "Settings"), systemImage: "gear")
                    Image(systemName: "gear")
                }
        }
    }
}

#Preview {
    TabsView()
}
