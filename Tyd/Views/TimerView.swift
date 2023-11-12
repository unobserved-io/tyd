//
//  TimerView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/12/23.
//

import SwiftData
import SwiftUI

struct TimerView: View {
    @Environment(TamponTimer.self) private var tamponTimer
    @Query var persistentTimer: [PersistentTimer]
    static var today: String { getTodaysDate() }
    @Query(filter: #Predicate<Day> { day in
        day.day == today
    }) var dayData: [Day]
    
    var body: some View {
        VStack {
            if tamponTimer.isRunning {
                Text("Change your \((tamponTimer.timedEvent?.product ?? Product.tampon).rawValue) in")
            } else {
                Text("")
            }
            Text(tamponTimer.formatted)
                .font(Font.monospacedDigit(.system(size: 80.0))())
                .lineLimit(1)
                .lineSpacing(0)
                .allowsTightening(false)
                .frame(maxHeight: 90)
                .padding(.horizontal)
            
            if !(tamponTimer.isRunning) {
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
