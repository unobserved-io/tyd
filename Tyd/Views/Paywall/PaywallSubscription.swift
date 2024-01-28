//
//  Paywall.swift
//  Tyd
//
//  Created by Ricky Kresslein on 1/4/24.
//

import StoreKit
import SwiftUI

struct PaywallSubscription: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        SubscriptionStoreView(groupID: "21429780") {
            VStack {
                Text("Tyd+")
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                    .bold()
                    .padding(.bottom)
                
                VStack(alignment: .listRowSeparatorLeading, spacing: 12.0) {
                    // Custom icons
                    HStack {
                        Image(systemName: "app.gift.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.accent)
                        VStack(alignment: .leading) {
                            Text("Change the icon")
                                .bold()
                            Text("Bedazzle your Home Screen")
                                .font(.caption)
                        }
                    }
                    
                    // Change the color
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .font(.system(size: 35))
                            .foregroundStyle(.accent)
                        VStack(alignment: .leading) {
                            Text("Custom color")
                                .bold()
                            Text("Let the app represent your style")
                                .font(.caption)
                        }
                    }
                    
                    // Live activities
                    HStack {
                        Image(systemName: "livephoto.play")
                            .font(.system(size: 35))
                            .foregroundStyle(.accent)
                        VStack(alignment: .leading) {
                            Text("Live Activity")
                                .bold()
                            Text("See the timer at a glance")
                                .font(.caption)
                        }
                    }
                    
                    // More to come
                    HStack {
                        Image(systemName: "visionpro.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.accent)
                        VStack(alignment: .leading) {
                            Text("More to come")
                                .bold()
                            Text("Future access to new features")
                                .font(.caption)
                        }
                    }
                }
                
                // MARK: Plans

                Text("Plans:")
                    .font(.callout.smallCaps())
                    .bold()
                    .foregroundStyle(.primary.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
            }
        }
        .storeButton(.visible, for: .restorePurchases)
        .storeButton(.visible, for: .cancellation) // X at top right
        .subscriptionStoreControlStyle(.prominentPicker)
        .subscriptionStorePolicyDestination(url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!, for: .termsOfService)
        .subscriptionStorePolicyDestination(for: .privacyPolicy) {
            Text("Tyd does not collect or transmit any user data.")
        }
        .onInAppPurchaseCompletion { _, result in
            if case .success(.success(_)) = result {
                dismiss()
            }
        }
    }
}

#Preview {
    PaywallSubscription()
}
