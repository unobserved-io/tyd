//
//  Stats.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import Foundation

@Observable
class Stats {
    var lastPeriod: Date? = nil
    var avgPeriodLength: Float? = nil
    var avgPmsDaysPerCycle: Float = 0
    var avgBleeding: [Float] = []
    var avgCycle: Int? = nil
    var daysUsingTyd: Int = 0
    var totalPeriodDays: Int = 0
    var totalPmsDays: Int = 0
    
    func resetAllStats() {
        self.lastPeriod = nil
        self.avgPeriodLength = nil
        self.avgPmsDaysPerCycle = 0
        self.avgBleeding = []
        self.avgCycle = nil
        self.daysUsingTyd = 0
        self.totalPeriodDays = 0
        self.totalPmsDays = 0
    }
    
    func updateStats(dayData: [DayData]) {
        let sortedDays = dayData.sorted(by: {
            dateFormatter.date(from: $0.day) ?? .now > dateFormatter.date(from: $1.day) ?? .now
        })
        sortedDays.forEach { day in
            print(day.day)
        }
    }
}
