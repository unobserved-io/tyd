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
    @Environment(TamponTimer.self) private var tamponTimer
    @Environment(Stats.self) private var stats
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    static var today: String { getTodaysDate() }
    @Query(filter: #Predicate<DayData> { day in
        day.day == today
    }) var dayData: [DayData]
    @State var longPressed = false
    
    var body: some View {
        VStack {
            if !(dayData.first?.period ?? false) {
                Text("DAY \(stats.daysSinceLastPeriod)")
                    .bold()
                    .padding(.bottom)
            }

            ZStack {
                if tamponTimer.isRunning {
                    ProgressBar(progress: tamponTimer.progress)
                        .offset(y: 40)
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
                        .imageScale(.small)
                        .opacity(dayData.first?.pms ?? false || dayData.first?.period ?? false ? 1.0 : 0.3)
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                        longPressed = true
                    }
                )
            }

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
