//
//  StatsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/14/23.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        VStack {
            Text("Last period: ") // Date
            Text("Avg period: ") // Number of days
            Text("Avg PMS days per cycle: ") // # of days
            Text("Avg bleeding by day: ")
            Text("Avg cycle: ")
            
            Text("Days using tyd: ")
            Text("Total period days: ")
            Text("Total PMS days: ")
            
            Text("Tooltip to record more data to see more stats")
        }
    }
}

#Preview {
    StatsView()
}
