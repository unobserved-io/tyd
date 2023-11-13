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
    @Query var appData: [AppData]
    
    var body: some View {
        VStack {
            if tamponTimer.isRunning {
                Text("Change your \((tamponTimer.product ?? Product.tampon).rawValue) in")
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
                    ForEach(Product.allCases, id: \.rawValue) { product in
                        Button(product.rawValue.capitalized) {
                            startTimer(with: product)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            
            if !(dayData.first?.timerData.isEmpty ?? true) {
                List {
                    ForEach(dayData.first?.timerData ?? []) { timedEvent in
                        Text(timedEvent.product.rawValue.capitalized)
                    }
                }
            }
        }
    }
    
    private func startTimer(with product: Product) {
        tamponTimer.start(product: product, interval: appData.first?.timerIntervals[product] ?? 4.0)
    }
}

#Preview {
    TimerView()
}
