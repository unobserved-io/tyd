//
//  LoadingView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import StoreKit
import SwiftData
import SwiftUI

struct LoadingView: View {
    @Environment(TimerHelper.self) private var timerHelper
    @Environment(Stats.self) private var stats
    @Environment(\.modelContext) private var modelContext
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs) private var passIDs

    @AppStorage("showLiveActivity") var showLiveActivity: Bool = false
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    @AppStorage("chosenIcon") var chosenIcon: String = AppIcons.primary.rawValue

    @Query private var appData: [AppData]
    @Query private var dayData: [DayData]
    @Query private var persistentTimer: [PersistentTimer]

    @State private var status: EntitlementTaskState<PassStatus> = .loading

    var body: some View {
        TabsView()
            .onAppear {
                // If AppData does not exist, create it
                if appData.first == nil {
                    modelContext.insert(AppData())
                }

                // Continue running timer if it was running when the app was closed and it is less than 48 hours old
                if persistentTimer.first != nil {
                    if persistentTimer.first?.isRunning ?? false && (Calendar.current.dateComponents([.hour], from: persistentTimer.first?.startTime ?? .distantPast, to: .now).hour ?? 50 < 48) {
                        timerHelper.product = persistentTimer.first?.product
                        timerHelper.startTime = persistentTimer.first?.startTime
                        timerHelper.resume(interval: appData.first?.timerIntervals[timerHelper.product ?? .tampon] ?? 4.0, liveActivity: showLiveActivity)
                    }
                }
            }
            .subscriptionStatusTask(for: "21429780") { taskStatus in
                self.status = await taskStatus.map { statuses in
                    await ProductSubscription.shared.status(
                        for: statuses,
                        ids: passIDs
                    )
                }
                switch self.status {
                case .failure(let error):
                    passStatusModel.passStatus = .notSubscribed
                    print("Failed to check subscription status: \(error)")
                case .success(let status):
                    passStatusModel.passStatus = status
                case .loading: break
                @unknown default: break
                }
                
                if passStatusModel.passStatus == .notSubscribed {
                    resetPaywalledFeatures()
                }
            }
    }
    
    private func resetPaywalledFeatures() {
        showLiveActivity = false
        tydAccentColor = "8B8BB0FF"
        chosenIcon = AppIcons.primary.rawValue
        UIApplication.shared.setAlternateIconName(chosenIcon)
    }
}

#Preview {
    LoadingView()
}
