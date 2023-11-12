//
//  TimerView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/12/23.
//

import SwiftData
import SwiftUI

struct TimerView: View {
//    @Environment(PersistentTimer.self) private var persistentTimer
    @Query var tamponTimer: [TamponTimer]
    static var today: String { getTodaysDate() }
    @Query(filter: #Predicate<Day> { day in
        day.day == today
    }) var dayData: [Day]
    // Create A
    
    var body: some View {
        VStack {
            if tamponTimer.first?.isRunning ?? false {
                Text("Change your \((tamponTimer.first?.timedEvent?.product ?? Product.tampon).rawValue) in")
            } else {
                Text("")
            }
            Text(tamponTimer.first?.formatted ?? "00:00:00")
                .font(Font.monospacedDigit(.system(size: 80.0))())
                .lineLimit(1)
                .lineSpacing(0)
                .allowsTightening(false)
                .frame(maxHeight: 90)
                .padding(.horizontal)
            
            if !(tamponTimer.first?.isRunning ?? true) {
                HStack {
                    Button("Tampon") {}
                        .buttonStyle(.borderedProminent)
                    Button("Pad") {}
                        .buttonStyle(.borderedProminent)
                    Button("Cup") {}
                        .buttonStyle(.borderedProminent)
                    Button("Underwear") {}
                        .buttonStyle(.borderedProminent)
                }
            }
            
            if dayData.first?.timerData.contains(where: { $0.stopTime != nil }) ?? false {
                List {
                    ForEach(dayData.first?.timerData ?? []) { timedEvent in
                        if timedEvent.stopTime != nil {
                            Text(timedEvent.product.rawValue)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TimerView()
}
