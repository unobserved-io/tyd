//
//  Stats.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import Foundation

@Observable
class Stats {
    static let shared = Stats()
    
    var lastPeriodEnd: Date?
    var lastPeriodStart: Date?
    var daysSinceLastPeriod: Int = 0
    var currentStartDate: Date?
    var avgPeriodLength: Int?
    var avgPmsDaysPerCycle: Float = 0
    var avgBleedingByDay: [Int: Float] = [:]
    var avgCycle: Int?
    var daysUsingTyd: Int?
    var totalPeriodDays: Int = 0
    var totalPmsDays: Int = 0
    var daysToNextCycle: Int = 0
    @ObservationIgnored var numberOfCycles: Int = 0
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
        self.daysUsingTyd = nil
        self.totalPeriodDays = 0
        self.totalPmsDays = 0
        self.daysToNextCycle = 0
        self.numberOfCycles = 0
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
        self.getDaysSinceLastPeriod(from: sortedDays)
        self.getDaysLengthBleedingAndCycle(from: sortedDays)
        
        // If on period, create an altered list without the first period
        if self.onPeriod {
            // Remove current period from sortedDays and save as alteredDays
            if sortedDays.count > 0 {
                var indexToRemove = 0
                for i in 0 ..< sortedDays.count {
                    if sortedDays[i].period {
                        indexToRemove = i
                    } else {
                        break
                    }
                }
                self.currentStartDate = dateFormatter.date(from: sortedDays[indexToRemove].day)
                alteredDays.removeSubrange(0 ... indexToRemove)
            }
        }
        
        // Get data using alteredDays, which may or may not be changed
        self.getLastPeriod(from: alteredDays)
//        self.getAvgCycle(from: alteredDays)
        self.getPmsDaysPerCycle()
        
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
    }
    
    func getDaysSinceLastPeriod(from dayData: [DayData]) {
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
        
        if lastPeriodStart != nil {
            let lastPeriodStartDate = dateFormatter.date(from: lastPeriodStart ?? "01.01.1974")
            self.daysSinceLastPeriod = (Calendar.current.dateComponents([.day], from: lastPeriodStartDate ?? .now, to: .now).day ?? 0) + 1
        } else {
            self.daysSinceLastPeriod = 0
        }
    }
    
    func getDaysLengthBleedingAndCycle(from dayData: [DayData]) {
        var periodStart: Date?
        var periodEnd: Date?
        var allPeriodLengths: [Int] = []
        var periodDay = 1
        var tempBleedingByDay: [Int: [Double]] = [:]
        var allStartDates: [Date] = []
        var cycleLengths: [Int] = []
        var cutOffCurrentPeriod = false
        
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
                    var daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: periodEnd ?? .now).day
                    if daysBetweenDates != nil {
                        // Add one to daysBetweenDates to include end date
                        daysBetweenDates! += 1
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
                    var daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: periodEnd ?? .now).day
                    if daysBetweenDates != nil {
                        // Add one to daysBetweenDates to include end date
                        daysBetweenDates! += 1
                        allPeriodLengths.append(daysBetweenDates!)
                        allStartDates.append(periodStart ?? .now)
                    }
                    
                    periodStart = nil
                    periodEnd = nil
                    periodDay = 1
                }
            }
        }
        
        // Do this once more at the end in case the last period is today
        if periodStart != nil {
            var daysBetweenDates = Calendar.current.dateComponents([.day], from: periodStart ?? .now, to: periodEnd ?? .now).day
            if daysBetweenDates != nil {
                // Add one to daysBetweenDates to include end date
                daysBetweenDates! += 1
                allPeriodLengths.append(daysBetweenDates!)
                allStartDates.append(periodStart ?? .now)
                cutOffCurrentPeriod = true
            }
            
            periodStart = nil
            periodEnd = nil
            periodDay = 1
        }
        
        // Record total period days
        self.totalPeriodDays = allPeriodLengths.sum()
        
        // Record total cycles
        self.numberOfCycles = allPeriodLengths.count
        
        // Record average period length
        if cutOffCurrentPeriod {
            let cutOffPeriodLengths = {
                var newList = allPeriodLengths
                newList.removeLast()
                return newList
            }()
            self.avgPeriodLength = Int(round(cutOffPeriodLengths.average()))
        } else {
            self.avgPeriodLength = Int(round(allPeriodLengths.average()))
        }
        // Calculate and record average bleeding by day
        tempBleedingByDay.forEach { dayNumber, bleedingNumbers in
            let avgBleedingUnrounded = Float(bleedingNumbers.sum()) / Float(bleedingNumbers.count)
            self.avgBleedingByDay[dayNumber] = Float(round(10.0 * (avgBleedingUnrounded)) / 10.0)
        }
        // Calculate average cycle
        for i in 0 ..< allStartDates.count {
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
        self.daysUsingTyd = nil
        for day in dayData.reversed() {
            if day.period || day.pms || !(day.timerData?.isEmpty ?? true) {
                let firstUseDate = dateFormatter.date(from: day.day)
                self.daysUsingTyd = (Calendar.current.dateComponents([.day], from: firstUseDate ?? .now, to: .now).day ?? 0) + 1
                return
            }
        }
    }
    
    func getTotalPMSDays(from dayData: [DayData]) {
        // TODO: Clean this up with better code that can do the same in 2 lines
        var pmsDays = 0
        for day in dayData {
            if day.pms {
                pmsDays += 1
            }
        }
        self.totalPmsDays = pmsDays
    }
    
    func getPmsDaysPerCycle() {
        let avgPmsDaysPerCycleUnrounded = Float(self.totalPmsDays) / Float(self.numberOfCycles)
        self.avgPmsDaysPerCycle = Float(round(10.0 * (avgPmsDaysPerCycleUnrounded)) / 10.0)
    }
}
