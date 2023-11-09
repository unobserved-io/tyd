//
//  MainView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftUI

struct TabsView: View {
//    @Environment(\.managedObjectContext) private var viewContext
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
//            TestView()
//                .tabItem {
//                    Image(systemName: "timer")
//                }
//
//            HomeView()
//                .tabItem {
//                    Image(systemName: "chart.bar")
//                }
//
//            HomeView()
//                .tabItem {
//                    Image(systemName: "gear")
//                }
        }
    }
}

#Preview {
    TabsView()
}
