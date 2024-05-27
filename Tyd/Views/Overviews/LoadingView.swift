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
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs) private var passIDs

    @AppStorage("showLiveActivity") var showLiveActivity: Bool = false
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    @AppStorage("chosenIcon") var chosenIcon: String = AppIcons.primary.rawValue
    
    @ObservedObject var storeModel = StoreModel.shared

    @State private var status: EntitlementTaskState<PassStatus> = .loading

    var body: some View {
        TabsView()
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
                    if passStatusModel.passStatus == .notSubscribed && storeModel.purchasedIds.isEmpty {
                        resetPaywalledFeatures()
                    }
                case .loading: break
                @unknown default: break
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
