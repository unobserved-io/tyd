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
                if appData.first == nil {
                    modelContext.insert(AppData())
                }
                stats.updateStats(dayData: dayData)
                // TODO: Uncomment and start timer if necessary
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
