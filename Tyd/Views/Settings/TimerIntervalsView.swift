//
//  TimerIntervalsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

import SwiftData
import SwiftUI

struct TimerIntervalsView: View {
    @Binding var intervals: [Product: Float]
    @State private var showingAlert: Bool = false
    @State private var newInterval: Float = 4.0
    @State private var showSliders: [Product: Bool] = [
        .tampon: false,
        .pad: false,
        .cup: false,
        .underwear: false
    ]
    
    var body: some View {
        Form {
            Section {
                ForEach(intervals.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { product, interval in
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
                                Text("\(interval.formatted(FloatingPointFormatStyle())) \(interval == 1.0 ? "hour" : "hours")").bold()
                            }
                        }
                        
                        if showSliders[product] ?? false {
                            Slider(
                                value: Binding(get: {
                                            intervals[product] ?? 4.0
                                        },
                                      set: { newValue in
                                          intervals[product] = newValue
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
}

#Preview {
    TimerIntervalsView(intervals: .constant([:]))
}
