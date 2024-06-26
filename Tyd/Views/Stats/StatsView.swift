//
//  StatsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import SwiftData
import SwiftUI

struct StatsView: View {    
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    
    @Query var appData: [AppData]
    
    @State private var showingMoreStatsMessage: Bool = false
    @State private var stats = Stats.shared
    @State var bleedingDay: Int = 1
    
    let dualInnerBoxColor: Color = .white.opacity(0.5)
    let monthDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Last Period
                    if stats.lastPeriodStart != nil && stats.lastPeriodEnd != nil {
                        VStack {
                            Text("Last Period")
                                .frame(alignment: .center)
                                .font(.title2)
                            Text("\(monthDay.string(from: stats.lastPeriodStart ?? .distantPast)) - \(monthDay.string(from: stats.lastPeriodEnd ?? .distantFuture))")
                                .frame(alignment: .center)
                                .font(.system(size: 45))
                                .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                                .padding(.top, 1)
                        }
                        .padding(.top)
                    }
                    
                    // Average period
                    if stats.avgPeriodLength ?? 0 != 0 {
                        VStack {
                            VStack {
                                HStack(alignment: .lastTextBaseline) {
                                    Text(String(stats.avgPeriodLength ?? 0))
                                        .font(.system(size: 55))
                                        .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                                    Text(stats.avgPeriodLength != 1 ? "days" : "day")
                                }
                                Text("Average period")
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .background((Color(hex: tydAccentColor) ?? .accent).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(alignment: .center)
                    }
                    
                    // Average PMS days/cycle
                    // Show only if there is an average cycle, otherwise this will be incorrect
                    if stats.avgCycle ?? 0 != 0 {
                        VStack {
                            Text(String(format: "%.1f", stats.avgPmsDaysPerCycle))
                                .font(.system(size: 55))
                                .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                            Text("Average PMS days per cycle")
                                .font(.title2)
                        }
                    }
                    
                    // Average bleeding on day x
                    if stats.avgCycle ?? 0 != 0 {
                        VStack {
                            VStack {
                                HStack {
                                    Button {
                                        leftArrowPressed()
                                    } label: {
                                        Image(systemName: "chevron.left").bold()
                                    }
                                    .padding(.leading)
                                    Spacer()
                                    Text(String(format: "%.1f", stats.avgBleedingByDay[bleedingDay] ?? 0))
                                        .font(.system(size: 55))
                                        .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                                    Spacer()
                                    Button {
                                        rightArrowPressed()
                                    } label: {
                                        Image(systemName: "chevron.right").bold()
                                    }
                                    .padding(.trailing)
                                }
                                
                                Text("Average bleeding on day \(String(bleedingDay))")
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .background((Color(hex: tydAccentColor) ?? .accent).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(alignment: .center)
                    }
                    
                    // Average cycle
                    if stats.avgCycle ?? 0 != 0 {
                        VStack {
                            HStack(alignment: .lastTextBaseline) {
                                Text(String(stats.avgCycle ?? 0))
                                    .font(.system(size: 55))
                                    .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                                Text(stats.avgCycle != 1 ? "days" : "day")
                            }
                            Text("Average cycle")
                                .font(.title2)
                        }
                    }
                    
                    // Tyd usage
                    VStack {
                        VStack {
                            VStack {
                                Text("Days using Tyd")
                                    .font(.title2)
                                Text(String(stats.daysUsingTyd ?? (Calendar.current.dateComponents([.day], from: appData.first?.firstDayUsingTyd ?? .now, to: .now).day ?? 0) + 1))
                                    .font(.system(size: 55))
                                    .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .background(dualInnerBoxColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(alignment: .center)
                        .padding(.horizontal)
                        .padding(.top)
                        HStack {
                            VStack {
                                VStack {
                                    Text(String(stats.totalPeriodDays))
                                        .font(.system(size: 55))
                                        .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                                    Text("Period days")
                                        .font(.title2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .background(dualInnerBoxColor)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(alignment: .center)
                            .padding(.leading)
                            .padding(.bottom)
                            VStack {
                                VStack {
                                    Text(String(stats.totalPmsDays))
                                        .font(.system(size: 55))
                                        .foregroundStyle(Color(hex: tydAccentColor) ?? .accent)
                                    Text("PMS Days")
                                        .font(.title2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .background(dualInnerBoxColor)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(alignment: .center)
                            .padding(.trailing)
                            .padding(.bottom)
                        }
                    }
                    .background((Color(hex: tydAccentColor) ?? .accent).opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(alignment: .center)
                    
                    if stats.lastPeriodStart == nil || stats.lastPeriodEnd == nil || stats.avgPeriodLength ?? 0 == 0 || stats.avgCycle ?? 0 == 0 {
                        Text("You will see more stats once you have recorded more data.")
                            .bold()
                            .padding(.top)
                    }
                }
                .padding()
                .navigationBarTitle("Stats")
            }
        }
    }
    
    func leftArrowPressed() {
        if bleedingDay > 1 {
            bleedingDay -= 1
        }
    }
    
    func rightArrowPressed() {
        if bleedingDay < stats.avgBleedingByDay.count {
            bleedingDay += 1
        }
    }
}

#Preview {
    StatsView()
}
