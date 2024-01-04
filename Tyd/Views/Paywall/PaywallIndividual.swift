//
//  PaywallIndividual.swift
//  Tyd
//
//  Created by Ricky Kresslein on 1/4/24.
//

import SwiftUI
import StoreKit

struct PaywallIndividual: View {
    var body: some View {
                VStack {
                    Text("Choose the plan that's best for you")
                        .font(.title)
                        .multilineTextAlignment(.center)
        
                    // MARK: Pro Features
                    Text("With a subscription, you get:")
                        .font(.callout.smallCaps())
                        .bold()
                        .foregroundStyle(.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
        
                    VStack(alignment: .listRowSeparatorLeading, spacing: 12.0) {
                        // Custom icons
                        HStack {
                            Image(systemName: "app.gift.fill")
                                .font(.system(size: 38))
                                .foregroundStyle(.accent)
                            VStack(alignment: .leading) {
                                Text("Custom icons")
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
                                Text("Change the color")
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
                    .padding(.horizontal)
                    .padding(.vertical, 10.0)
        
                    // MARK: Plans
                    Text("Plans:")
                        .font(.callout.smallCaps())
                        .bold()
                        .foregroundStyle(.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    StoreView(
                        ids: [
                            "monthly1",
                            "yearly9",
                            "onetime15"
                        ]
                    )
                    .productViewStyle(.compact)
//                    .storeButton(.visible, for: .restorePurchases)
                    
                    // MARK: Subscribe
                    Spacer()
        
                    Text("Cancel anytime in Settings")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
//                        .padding(.bottom)
        
                    Button {
        
                    } label: {
                        Text("Start 7-Day Free Trial")
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
        
                    Button("Restore Purchase") {}
                    
                }
                    
            }
}

#Preview {
    PaywallIndividual()
}
