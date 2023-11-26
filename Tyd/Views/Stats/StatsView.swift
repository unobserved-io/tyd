//
//  StatsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import SwiftUI

struct StatsView: View {
    @Environment(Stats.self) private var stats
    let monthDay: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            Text("Last period: \(monthDay.string(from: stats.lastPeriodEnd ?? .distantPast))") // Date
            Text("Avg period length: \(stats.avgPeriodLength ?? 0)") // Number of days
            Text("Avg PMS days per cycle: ") // # of days
            Text("Avg bleeding on day one: \(stats.avgBleedingByDay[1] ?? 0)")
            Text("Avg cycle: ")
            
            Text("Days using tyd: \(stats.daysUsingTyd)")
            Text("Total period days: \(stats.totalPeriodDays)")
            Text("Total PMS days: \(stats.totalPmsDays)")
            
            Text("Tooltip to record more data to see more stats")
        }
    }
}

#Preview {
    StatsView()
}
