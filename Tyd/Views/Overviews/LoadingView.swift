//
//  LoadingView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftData
import SwiftUI

struct LoadingView: View {
    @Environment(TamponTimer.self) private var tamponTimer
    @Environment(\.modelContext) private var modelContext
    @Query private var appData: [AppData]
    @Query var persistentTimer: [PersistentTimer]

    var body: some View {
        TabsView()
            .onAppear {
                if appData.first == nil {
                    modelContext.insert(AppData())
                }
                if persistentTimer.first == nil {
                    modelContext.insert(PersistentTimer())
                } else {
                    tamponTimer.isRunning = persistentTimer.first?.isRunning ?? false
                    if tamponTimer.isRunning {
                        tamponTimer.timedEvent = persistentTimer.first?.timedEvent
                    }
                }
            }
    }
}

#Preview {
    LoadingView()
}
