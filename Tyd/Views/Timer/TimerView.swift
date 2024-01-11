//
//  TimerView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/12/23.
//

import SwiftData
import SwiftUI

struct TimerView: View {
    @Environment(TimerHelper.self) private var timerHelper
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @AppStorage("showLiveActivity") var showLiveActivity: Bool = false
    @Query private var persistentTimer: [PersistentTimer]
    static var today: String { getTodaysDate() }
    @Query(filter: #Predicate<DayData> { day in
        day.day == today
    }) var dayData: [DayData]
    @Query var appData: [AppData]
    @State var showingEditTimedEventSheet: Bool = false
    @State var tappedTimedEvent: TimedEvent = .init(product: .tampon, startTime: .now, stopTime: .now)
    @State private var showingStartTimeSheet: Bool = false
    let tenSecsFromNow = Calendar.current.date(byAdding: .second, value: 10, to: .now)
    
    var body: some View {
        VStack {
            if timerHelper.isRunning {
                // TODO: Can I replace this with somehting that happens only onAppear or some other way so I don't need a timer?
                if timerHelper.ended {
                    Text("Time since you should have changed your \((timerHelper.product ?? PeriodProduct.tampon).rawValue)")
                } else {
                    Text("Change your \((timerHelper.product ?? PeriodProduct.tampon).rawValue) in")
                }
            } else {
                Text("")
            }
            if timerHelper.isRunning {
                Text(
                    timerHelper.endTime ?? .now,
                    style: .timer
                )
                .font(Font.monospacedDigit(.system(size: 80.0))())
                .lineLimit(1)
                .lineSpacing(0)
                .allowsTightening(false)
                .frame(maxHeight: 90)
                .multilineTextAlignment(.center)
            } else {
                Text("00:00:00")
                    .font(Font.monospacedDigit(.system(size: 80.0))())
                    .lineLimit(1)
                    .lineSpacing(0)
                    .allowsTightening(false)
                    .frame(maxHeight: 90)
                    .multilineTextAlignment(.center)
            }
            
            if !(timerHelper.isRunning) {
                HStack {
                    ForEach(PeriodProduct.allCases, id: \.rawValue) { product in
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
                    Button {
                        showingStartTimeSheet.toggle()
                    } label: {
                        Text(timerHelper.startTime?.formatted(date: .omitted, time: .shortened) ?? "12:00")
                    }
                    .buttonStyle(.bordered)
                    
                    Button {
                        stopTimer()
                    } label: {
                        Image(systemName: "stop.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        let lastProductUsed = timerHelper.product ?? .tampon
                        stopTimer()
                        startTimer(with: lastProductUsed)
                    } label: {
                        Image(systemName: "repeat")
                    }
                    .buttonStyle(.bordered)
                }
                .sheet(isPresented: $showingStartTimeSheet) {
                    DatePicker(
                        "Change start time",
                        selection: Binding(get: {
                                               timerHelper.startTime ?? .now
                                           },
                                           set: { newValue in
                                               timerHelper.startTime = newValue
                                           }),
                        in: getDateADayAgo() ... Date.now,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .onChange(of: timerHelper.startTime) {
                        persistentTimer.first?.startTime = timerHelper.startTime
                        timerHelper.updateEndTime()
                        timerHelper.updateNotificationTime()
#if os(iOS)
                        Task {
                            await timerHelper.updateLiveActivity()
                        }
#endif
                    }
                    .presentationDetents([.small])
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
                                Text("\(timedEvent.startTime.formatted(date: .omitted, time: .shortened)) - \(timedEvent.stopTime.formatted(date: .omitted, time: .shortened))")
                                    .lineLimit(1)
                                    .opacity(0.626)
                            }
                        }
                    }
                    .onDelete(perform: deleteTimerData)
                }
                .sheet(isPresented: $showingEditTimedEventSheet) {
                    EditTimedEventView(timedEvent: $tappedTimedEvent)
                        .presentationDetents(dynamicTypeSize <= .xxLarge ? [.small] : [])
                }
            }
        }
    }
    
    private func startTimer(with product: PeriodProduct) {
        timerHelper.start(product: product, interval: appData.first?.timerIntervals[product] ?? 4.0, liveActivity: showLiveActivity)
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
        return Calendar.current.date(byAdding: .second, value: -86399, to: .now) ?? .now
    }
    
    private func initiatePersistentTimer() {
        if persistentTimer.first == nil {
            let newPersistentTimer = PersistentTimer()
            newPersistentTimer.isRunning = true
            newPersistentTimer.product = timerHelper.product ?? .tampon
            newPersistentTimer.startTime = timerHelper.startTime
            modelContext.insert(PersistentTimer())
        } else {
            persistentTimer.first?.isRunning = true
            persistentTimer.first?.product = timerHelper.product ?? .tampon
            persistentTimer.first?.startTime = timerHelper.startTime
        }
    }
    
    private func resetPersistentTimer() {
        persistentTimer.first?.isRunning = false
        persistentTimer.first?.startTime = nil
    }
    
    private func stopTimer() {
        timerHelper.stop()
        let newTimedEvent = TimedEvent(product: timerHelper.product ?? .tampon, startTime: timerHelper.startTime ?? .now, stopTime: timerHelper.stopTime ?? .now)
        modelContext.insert(newTimedEvent)
        dayData.first?.timerData.append(newTimedEvent)
        timerHelper.resetTimedEventData()
        resetPersistentTimer()
    }
}

#Preview {
    TimerView()
}
