//
//  Stats.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import Foundation

@Observable
class Stats {
    var lastPeriodEnd: Date?
    var lastPeriodStart: Date?
    var daysSinceLastPeriod: Int = 0
    var currentStartDate: Date?
    var avgPeriodLength: Int?
    var avgPmsDaysPerCycle: Float = 0
    var avgBleedingByDay: [Int: Float] = [:]
    var avgCycle: Int?
    var daysUsingTyd: Int = 0
    var totalPeriodDays: Int = 0
    var totalPmsDays: Int = 0
    var daysToNextCycle: Int = 0
    @ObservationIgnored var onPeriod = false
    
    func resetAllStats() {
        self.lastPeriodEnd = nil
        self.lastPeriodStart = nil
        self.daysSinceLastPeriod = 0
        self.currentStartDate = nil
        self.avgPeriodLength = nil
        self.avgPmsDaysPerCycle = 0
        self.avgBleedingByDay = [:]
        self.avgCycle = nil
        self.daysUsingTyd = 0
        self.totalPeriodDays = 0
        self.totalPmsDays = 0
        self.daysToNextCycle = 0
        self.onPeriod = false
    }
    
    func updateAllStats(from dayData: [DayData]) {
        self.resetAllStats()
        let sortedDays = dayData.sorted(by: {
            dateFormatter.date(from: $0.day) ?? .now > dateFormatter.date(from: $1.day) ?? .now
        })
        var alteredDays: [DayData] = sortedDays
        
        self.getTotalDaysUsingTyd(from: sortedDays)
        self.getTotalPMSDays(from: sortedDays)
        self.getCurrentPeriodStart(from: sortedDays)
        
        // If on period, create an altered list without the first period
        if self.onPeriod {
            // Remove current period from sortedDays and save as alteredDays
            var indexToRemove = 0
            for i in 0...sortedDays.count {
                if sortedDays[i].period {
                    indexToRemove = i
                } else {
                    break
                }
            }
            self.currentStartDate = dateFormatter.date(from: sortedDays[indexToRemove].day)
            alteredDays.removeSubrange(0...indexToRemove)
        }
        
        // Get data using alteredDays, which may or may not be changed
        self.getLastPeriod(from: alteredDays)
        self.getDaysLengthAndBleeding(from: alteredDays)
        self.getAvgCycle(from: alteredDays)
        self.getPmsDaysPerCycle(from: alteredDays)
        
        self.daysToNextCycle = (self.avgCycle ?? 0) - self.daysSinceLastPeriod
    }
    
    func getCurrentPeriodStart(from dayData: [DayData]) {
        if Calendar.current.isDateInToday(dateFormatter.date(from: dayData.first?.day ?? "") ?? Date.distantPast), dayData.first?.period ?? false {
            self.onPeriod = true
            var dayBefore: Date?
            for day in dayData {
                let parsedDate = dateFormatter.date(from: day.day) ?? .now
                if dayBefore == nil, day.period {
                    self.currentStartDate = parsedDate
                    dayBefore = parsedDate
                } else if Calendar.current.isDate(parsedDate, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: dayBefore ?? .now) ?? .now), day.period {
                    self.currentStartDate = parsedDate
                    dayBefore = parsedDate
                } else {
                    return
                }
            }
        }
    }
    
    func getLastPeriod(from dayData: [DayData]) {
        var lastPeriodStart: String?
        var lastPeriodEnd: String?
        var lastDate: Date?
        
        for day in dayData {
            let parsedDate = dateFormatter.date(from: day.day) ?? .distantFuture
            if day.period {
                if lastPeriodEnd == nil {
                    lastPeriodEnd = day.day
                    lastPeriodStart = day.day
                } else if Calendar.current.isDate(parsedDate, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: lastDate ?? .distantPast) ?? .distantPast) {
                    lastPeriodStart = day.day
                }
                lastDate = dateFormatter.date(from: day.day) ?? .now
            } else if lastPeriodEnd != nil {
                break
            }
        }
        
        self.lastPeriodStart = dateFormatter.date(from: lastPeriodStart ?? "01.01.1974")
        self.lastPeriodEnd = dateFormatter.date(from: lastPeriodEnd ?? "01.01.1974")
        self.daysSinceLastPeriod = Calendar.current.dateComponents([.day], from: self.lastPeriodEnd ?? .now, to: .now).day ?? 0
    }
    
    func getDaysLengthAndBleeding(from dayData: [DayData]) {
        var periodStart: Date?
        var periodEnd: Date?
        var allPeriodLengths: [Int] = []
        var periodDay = 1
        var tempBleedingByDay: [Int: [Double]] = [:]
        var allStartDates: [Date] = []
        var cycleLengths: [Int] = []
        
        for day in dayData.reversed() {
            if day.period {
                let parsedDate = dateFormatter.date(from: day.day)
                if periodStart == nil {
                    // This is the first day, so record start and end
                    periodStart = parsedDate
                    periodEnd = parsedDate
                    
                    // Update bleeding numbers
                    if tempBleedingByDay[periodDay] != nil {
                        tempBleedingByDay[periodDay]?.append(day.bleeding)
                    } else {
                        tempBleedingByDay[periodDay] = [day.bleeding]
                    }
                } else if Calendar.current.isDate(parsedDate ?? .distantFuture, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: periodEnd ?? .distantPast) ?? .distantPast) {
                    // Still within period, record end
                    periodEnd = parsedDate
                    
                    // Update bleeding numbers
                    periodDay += 1
                    if tempBleedingByDay[periodDay] != nil {
                        tempBleedingByDay[periodDay]?.append(day.bleeding)
                    } else {
                        tempBleedingByDay[periodDay] = [day.bleeding]
                    }
                } else {
                    // Last period is over, save length and start a new one
                    //                    print("Period: \(periodStart ?? .now) to \(periodEnd ?? .now)")
                    let daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: periodEnd ?? .now).day
                    if daysBetweenDates != nil {
                        allPeriodLengths.append(daysBetweenDates!)
                        allStartDates.append(periodStart ?? .now)
                    }
                    
                    // Starting a new period, record start and end
                    periodStart = parsedDate
                    periodEnd = parsedDate
                    
                    // Reset period day and update bleeding numbers
                    periodDay = 1
                    if tempBleedingByDay[periodDay] != nil {
                        tempBleedingByDay[periodDay]?.append(day.bleeding)
                    } else {
                        tempBleedingByDay[periodDay] = [day.bleeding]
                    }
                }
            } else {
                if periodStart != nil {
                    //                    print("Period: \(periodStart ?? .now) to \(periodEnd ?? .now)")
                    let daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: periodEnd ?? .now).day
                    if daysBetweenDates != nil {
                        allPeriodLengths.append(daysBetweenDates!)
                        allStartDates.append(periodStart ?? .now)
                    }
                    
                    periodStart = nil
                    periodEnd = nil
                    periodDay = 1
                }
            }
        }
        
        //        print("Period lengths: \(allPeriodLengths)")
        // Record total period days
        self.totalPeriodDays = allPeriodLengths.sum()
        // Record average period length
        self.avgPeriodLength = allPeriodLengths.average()
        // Calculate and record average bleeding by day
        tempBleedingByDay.forEach { dayNumber, bleedingNumbers in
            self.avgBleedingByDay[dayNumber] = Float(bleedingNumbers.sum()) / Float(bleedingNumbers.count)
        }
        // Calculate average cycle
        for i in 0...allStartDates.count {
            if i + 1 <= (allStartDates.count - 1) {
                let daysBetween = Calendar.current.dateComponents([.day], from: allStartDates[i], to: allStartDates[i + 1]).day
                if daysBetween != nil {
                    cycleLengths.append(daysBetween!)
                }
            }
        }
        if cycleLengths.isEmpty {
            self.avgCycle = 0
        } else {
            self.avgCycle = cycleLengths.average()
        }
    }
    
    func getTotalDaysUsingTyd(from dayData: [DayData]) {
        let firstUseDate = dateFormatter.date(from: dayData.last?.day ?? "01.01.1975")
        self.daysUsingTyd = Calendar.current.dateComponents([.day], from: firstUseDate ?? .now, to: .now).day ?? 0
    }
    
    func getTotalPMSDays(from dayData: [DayData]) {
        var pmsDays = 0
        for day in dayData {
            if day.pms {
                pmsDays += 1
            }
        }
        self.totalPmsDays = pmsDays
    }
    
    func getAvgCycle(from dayData: [DayData]) {
        var periodStart: Date?
        var periodEnd: Date?
        var cycleEnd: Date?
        var allCycleLengths: [Int] = []
        
        for day in dayData.reversed() {
            let parsedDate = dateFormatter.date(from: day.day)
            if day.period {
                if periodStart == nil {
                    // This is the first day, so record start and end
                    periodStart = parsedDate
                    periodEnd = parsedDate
                    cycleEnd = parsedDate
                } else if Calendar.current.isDate(parsedDate ?? .distantFuture, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: periodEnd ?? .distantPast) ?? .distantPast) {
                    // Still within period, record end
                    periodEnd = parsedDate
                    cycleEnd = parsedDate
                } else {
                    // Last period is over, save length and start a new one
//                    print("Cycle: \(periodStart ?? .now) to \(cycleEnd ?? .now)")
                    let daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: cycleEnd ?? .now).day
                    if daysBetweenDates != nil {
                        allCycleLengths.append(daysBetweenDates!)
                    }
                    
                    // Starting a new period, record start and end
                    periodStart = parsedDate
                    periodEnd = parsedDate
                    cycleEnd = parsedDate
                }
            } else {
                if Calendar.current.isDate(parsedDate ?? .distantFuture, inSameDayAs: calendar.date(byAdding: .day, value: 1, to: cycleEnd ?? .distantPast) ?? .distantPast) {
                    cycleEnd = parsedDate
                } else if periodStart != nil {
//                    print("Cycle: \(periodStart ?? .now) to \(cycleEnd ?? .now)")
                    let daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: cycleEnd ?? .now).day
                    if daysBetweenDates != nil {
                        allCycleLengths.append(daysBetweenDates!)
                    }
                    periodStart = nil
                    periodEnd = nil
                    cycleEnd = nil
                }
            }
        }
    }
    
    func getPmsDaysPerCycle(from dayData: [DayData]) {
        var pmsDays = 0
        var allPmsDays: [Int] = []
        var newCycle = true
        var hasBeenPeriod = false
        
        for day in dayData.reversed() {
            if day.period {
//                print("\(day.day): Period")
                if !hasBeenPeriod {
                    hasBeenPeriod = true
                }
                
                if !newCycle {
                    allPmsDays.append(pmsDays)
                    pmsDays = 0
                }
                newCycle = true
            } else if day.pms {
                if hasBeenPeriod {
                    pmsDays += 1
                    newCycle = false
                }
//                print("\(day.day): PMS (\(pmsDays))")
            } else {
//                print("\(day.day): None")
                if hasBeenPeriod {
                    newCycle = false
                }
            }
        }
        
        if dayData.count >= 2 {
            if !(dayData.reversed().last?.period ?? false) {
                allPmsDays.append(pmsDays)
            }
        }
        
//        print("allPmsDays: \(allPmsDays)")
        self.avgPmsDaysPerCycle = allPmsDays.average()
    }
}
