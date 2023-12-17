//
//  StatsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import SwiftUI

struct StatsView: View {
    @Environment(Stats.self) private var stats
    let dualInnerBoxColor: Color = .white.opacity(0.5)
    let boxColor: Color = .accent.opacity(0.2)
    let monthDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter
    }()

    @State var bleedingDay: Int = 1
    
    var body: some View {
        ScrollView {
            VStack {
                // Last Period
                VStack {
                    Text("Last Period")
                        .frame(alignment: .center)
                        .font(.title2)
                    Text("\(monthDay.string(from: stats.lastPeriodStart ?? .distantPast)) - \(monthDay.string(from: stats.lastPeriodEnd ?? .distantFuture))")
                        .frame(alignment: .center)
                        .font(.system(size: 55))
                        .foregroundStyle(.accent)
                }
                .padding(.top)
                
                // Average period
                VStack {
                    VStack {
                        HStack(alignment: .lastTextBaseline) {
                            Text(String(stats.avgPeriodLength ?? 0))
                                .font(.system(size: 55))
                                .foregroundStyle(.accent)
                            Text(stats.avgPeriodLength != 1 ? "days" : "day")
                        }
                        Text("Average period")
                            .font(.title2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background(boxColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(alignment: .center)
                
                // Average PMS days/cycle
                VStack {
                    Text(String(format: "%.1f", stats.avgPmsDaysPerCycle))
                        .font(.system(size: 55))
                        .foregroundStyle(.accent)
                    Text("Average PMS days per cycle")
                        .font(.title2)
                }
                
                // Average bleeding on day x
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
                                .foregroundStyle(.accent)
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
                .background(boxColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(alignment: .center)
                
                // Average cycle
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        Text(String(stats.avgCycle ?? 0))
                            .font(.system(size: 55))
                            .foregroundStyle(.accent)
                        Text(stats.avgCycle != 1 ? "days" : "day")
                    }
                    Text("Average cycle")
                        .font(.title2)
                }
                
                // Tyd usage
                VStack {
                    VStack {
                        VStack {
                            Text("Days using Tyd")
                                .font(.title2)
                            Text(String(stats.daysUsingTyd))
                                .font(.system(size: 55))
                                .foregroundStyle(.accent)
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
                                    .foregroundStyle(.accent)
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
                                    .foregroundStyle(.accent)
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
                .background(.accent.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(alignment: .center)
            }
            .padding()
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
