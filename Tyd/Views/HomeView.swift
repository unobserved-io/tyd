//
//  ContentView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var days: [Day]
    
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Day.self, inMemory: true)
}
