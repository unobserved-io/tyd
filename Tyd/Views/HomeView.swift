//
//  ContentView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(TimerHelper.self) private var timerHelper
    @Environment(Stats.self) private var stats
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    static var today: String { getTodaysDate() }
    @Query(filter: #Predicate<DayData> { day in
        day.day == today
    }) var dayData: [DayData]
    @State var longPressed = false

    var body: some View {
        VStack {
            if !(dayData.first?.period ?? false) && stats.daysSinceLastPeriod > 0 {
                Text("DAY \(stats.daysSinceLastPeriod)")
                    .bold()
                    .padding(.bottom)
            }

            Button {
                if longPressed {
                    if dayData.first?.pms ?? false {
                        dayData.first?.pms = false
                    } else if !(dayData.first?.pms ?? true) && !(dayData.first?.period ?? true) {
                        dayData.first?.pms = true
                    } else if dayData.first?.period ?? false {
                        dayData.first?.period = false
                    }
                    longPressed = false
                } else {
                    if dayData.first?.pms ?? false {
                        dayData.first?.pms = false
                    } else {
                        dayData.first?.period.toggle()
                    }
                }
            } label: {
                Image("TydLogo")
                    .opacity(dayData.first?.pms ?? false || dayData.first?.period ?? false ? 1.0 : 0.3)
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                    longPressed = true
                }
            )

            if !(dayData.first?.pms ?? false || dayData.first?.period ?? false) {
                VStack {
                    Text("Tap for period, hold for PMS")
                        .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                }
                .padding(.top)
            } else {
                if dayData.first?.pms ?? false {
                    VStack {
                        Text("PMS")
                            .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                    }
                    .padding(.top)
                } else if dayData.first?.period ?? false {
                    VStack {
                        Text("Period")
                            .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                    }
                    .padding(.top)
                }
            }

            if timerHelper.isRunning {
                ProgressView(
                    timerInterval: (timerHelper.startTime ?? .now) ... (timerHelper.endTime ?? .distantFuture),
                    countsDown: false,
                    label: { EmptyView() },
                    currentValueLabel: { EmptyView() }
                )
                .frame(maxWidth: 150.0)
                .padding(.top, 12.0)
            }

            if !(dayData.first?.period ?? false) && stats.avgCycle ?? 0 > 0 {
                Text("~\(stats.daysToNextCycle) days until your next period")
                    .padding(.top)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                if dayData.first == nil {
                    modelContext.insert(DayData(day: getTodaysDate()))
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: DayData.self, inMemory: true)
}
