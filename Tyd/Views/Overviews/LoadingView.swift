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

                // Continue running timer if it was running when the app was closed
                if persistentTimer.first != nil {
                    if persistentTimer.first?.isRunning ?? false {
                        tamponTimer.product = persistentTimer.first?.product
                        tamponTimer.startTime = persistentTimer.first?.startTime
                        tamponTimer.resume(interval: appData.first?.timerIntervals[tamponTimer.product ?? .tampon] ?? 4.0)
                    }
                }
            }
    }
}

#Preview {
    LoadingView()
}
