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
    @Environment(\.modelContext) private var modelContext
    @Query private var persistentTimer: [PersistentTimer]
    static var today: String { getTodaysDate() }
    @Query(filter: #Predicate<DayData> { day in
        day.day == today
    }) var dayData: [DayData]
    @Query var appData: [AppData]
    @State var showingEditTimedEventSheet: Bool = false
    @State var tappedTimedEvent: TimedEvent = .init(product: .tampon, startTime: .now, stopTime: .now)
    
    var body: some View {
        VStack {
            if tamponTimer.isRunning {
                if tamponTimer.timesUp {
                    Text("Time since you changed your \((tamponTimer.product ?? Product.tampon).rawValue)")
                } else {
                    Text("Change your \((tamponTimer.product ?? Product.tampon).rawValue) in")
                }
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
                            initiatePersistentTimer()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!(dayData.first?.period ?? false))
                    }
                }
                if !(dayData.first?.period ?? false) {
                    Text("Begin period to use tampon timer.")
                        .padding(.top, 10)
                }
            } else {
                HStack {
                    DatePicker(
                        "Change start time",
                        selection: Binding(get: {
                                               tamponTimer.startTime ?? .now
                                           },
                                           set: { newValue in
                                               tamponTimer.startTime = newValue
                                           }),
                        in: getDateADayAgo() ... Date.now
                    )
                    .labelsHidden()
                    .onChange(of: tamponTimer.startTime) {
                        tamponTimer.updateNotificationTime()
                    }
                    
                    Button("Stop") {
                        stopTimer()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            if !(dayData.first?.timerData.isEmpty ?? true) {
                List {
                    ForEach((dayData.first?.timerData ?? []).sorted(by: { $0.stopTime > $1.stopTime })) { timedEvent in
                        Button {
                            tappedTimedEvent = timedEvent
                            showingEditTimedEventSheet.toggle()
                        } label: {
                            HStack {
                                Text(timedEvent.product.rawValue.capitalized)
                                Spacer()
                                Text("\(timeFormatter.string(from: timedEvent.startTime)) - \(timeFormatter.string(from: timedEvent.stopTime))")
                                    .lineLimit(1)
                                    .opacity(0.626)
                            }
                        }
                    }
                    .onDelete(perform: deleteTimerData)
                }
                .sheet(isPresented: $showingEditTimedEventSheet) {
                    EditTimedEventView(timedEvent: $tappedTimedEvent)
                        .presentationDetents([.small])
                }
            }
        }
    }
    
    private func startTimer(with product: Product) {
        tamponTimer.start(product: product, interval: appData.first?.timerIntervals[product] ?? 4.0)
    }
    
    private func deleteTimerData(at offsets: IndexSet) {
        for index in offsets {
            let timedEventToMatch: TimedEvent = (dayData.first?.timerData ?? []).sorted(by: { $0.stopTime > $1.stopTime })[index]
            if let indexToRemove = dayData.first?.timerData.firstIndex(where: { $0 == timedEventToMatch }) {
                dayData.first?.timerData.remove(at: indexToRemove)
                modelContext.delete(timedEventToMatch)
            }
        }
    }
    
    private func getDateADayAgo() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now
    }
    
    private func initiatePersistentTimer() {
        if persistentTimer.first == nil {
            let newPersistentTimer = PersistentTimer()
            newPersistentTimer.isRunning = true
            newPersistentTimer.product = tamponTimer.product ?? .tampon
            newPersistentTimer.startTime = tamponTimer.startTime
            modelContext.insert(PersistentTimer())
        } else {
            persistentTimer.first?.isRunning = true
            persistentTimer.first?.product = tamponTimer.product ?? .tampon
            persistentTimer.first?.startTime = tamponTimer.startTime
        }
    }
    
    private func resetPersistentTimer() {
        persistentTimer.first?.isRunning = false
        persistentTimer.first?.startTime = nil
    }
    
    private func stopTimer() {
        tamponTimer.stop()
        let newTimedEvent = TimedEvent(product: tamponTimer.product ?? .tampon, startTime: tamponTimer.startTime ?? .now, stopTime: tamponTimer.stopTime ?? .now)
        modelContext.insert(newTimedEvent)
        dayData.first?.timerData.append(newTimedEvent)
        tamponTimer.resetTimedEventData()
        resetPersistentTimer()
    }
}

#Preview {
    TimerView()
}
