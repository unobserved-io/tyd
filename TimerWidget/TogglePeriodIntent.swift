//
//  TogglePeriodIntent.swift
//  Tyd
//
//  Created by Ricky Kresslein on 5/2/24.
//

import AppIntents
import SwiftData
import WidgetKit

struct TogglePeriodIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Period"
    static var description: IntentDescription? = "Toggles your period on/off in Tyd."
        
    @MainActor
    func perform() async throws -> some IntentResult {
        var today: String {
            let dateFormatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter
            }()
            return dateFormatter.string(from: Date.now)
        }

        let modelContext = ModelContext(DayData.container)
        guard let dayData = try! modelContext.fetch(
            FetchDescriptor<DayData>(predicate: #Predicate { day in
                day.day == today
            })
        ).first else {
            return .result()
        }
        
        let onPeriod = dayData.period
        dayData.period = !onPeriod
                
        return .result()
    }
    
}
