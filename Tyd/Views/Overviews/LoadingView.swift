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
    @Environment(Stats.self) private var stats
    @Environment(\.modelContext) private var modelContext
    @Query private var appData: [AppData]
    @Query private var dayData: [DayData]
    @Query private var persistentTimer: [PersistentTimer]

    var body: some View {
        TabsView()
            .onAppear {
                // If AppData does not exist, create it
                if appData.first == nil {
                    modelContext.insert(AppData())
                }

                // TODO: Continue running timer if it was running when the app was closed
//                if persistentTimer.first == nil {
//                    modelContext.insert(PersistentTimer())
//                } else {
//                    tamponTimer.isRunning = persistentTimer.first?.isRunning ?? false
//                    if tamponTimer.isRunning {
//                        tamponTimer.product = persistentTimer.first?.product
//                        tamponTimer.startTime = persistentTimer.first?.startTime
//                    }
//                }
            }
    }
}

#Preview {
    LoadingView()
}
