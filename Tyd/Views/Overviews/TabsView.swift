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
                    Label(String(localized: "Home"), systemImage: "house")
                }
        }
    }
}

#Preview {
    TabsView()
}
