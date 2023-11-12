//
//  LoadingView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftData
import SwiftUI

struct LoadingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var appData: [AppData]
    @Query var persistentTimer: [TamponTimer]

    var body: some View {
        TabsView()
            .onAppear {
                if appData.first == nil {
                    modelContext.insert(AppData())
                }
                if persistentTimer.first == nil {
                    modelContext.insert(TamponTimer())
                }
            }
    }
}

#Preview {
    LoadingView()
}
