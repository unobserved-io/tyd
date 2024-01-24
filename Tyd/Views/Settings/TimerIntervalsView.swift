//
//  TimerIntervalsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

import SwiftData
import SwiftUI

struct TimerIntervalsView: View {
    @Binding var intervals: [Float]
    @State private var showingAlert: Bool = false
    @State private var newInterval: Float = 4.0
    @State private var showSliders: [PeriodProduct: Bool] = [
        .tampon: false,
        .pad: false,
        .cup: false,
        .underwear: false
    ]
    
    var body: some View {
        Form {
            Section {
                ForEach(PeriodProduct.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.rawValue) { product in
                    let intervalPosition = getIntervalPosition(for: product)
                    VStack {
                        Button {
                            // Close all other product sliders
                            showSliders.keys.forEach {
                                if $0 != product {
                                    showSliders[$0] = false
                                }
                            }
                            // Toggle the tapped product slider
                            showSliders[product]?.toggle()
                        } label: {
                            HStack {
                                Text(product.rawValue.capitalized)
                                Spacer()
                                Text("\(intervals[intervalPosition].formatted(FloatingPointFormatStyle())) \(intervals[intervalPosition] == 1.0 ? "hour" : "hours")").bold()
                            }
                        }
                        
                        if showSliders[product] ?? false {
                            Slider(
                                value: Binding(get: {
                                            intervals[intervalPosition]
                                        },
                                      set: { newValue in
                                          intervals[intervalPosition] = newValue
                                      }),
                                in: 0.5 ... 12,
                                step: 0.5
                            )
                        }
                    }
                }
            }
        }
    }
    
    func getIntervalPosition(for product: PeriodProduct) -> Int {
        switch product {
        case .cup: return 0
        case .pad: return 1
        case .tampon: return 2
        case .underwear: return 3
        }
    }
}

#Preview {
    TimerIntervalsView(intervals: .constant([]))
}
