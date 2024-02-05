//
//  StopTimerIntent.swift
//  TimerWidgetExtension
//
//  Created by Ricky Kresslein on 29/1/24.
//

import AppIntents
import SwiftData
import WidgetKit

struct StopTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Tyd Timer"
    static var description: IntentDescription? = "Stops the currently running Tyd timer"
        
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
        
        let timerHelper = TimerHelper.shared
        timerHelper.stop()
        
        let newTimedEvent = TimedEvent(product: timerHelper.product ?? .tampon, startTime: timerHelper.startTime ?? .now, stopTime: timerHelper.stopTime ?? .now)
        modelContext.insert(newTimedEvent)
        dayData.timerData?.append(newTimedEvent)
        timerHelper.resetTimedEventData()
        
        if let persistentTimer = try? modelContext.fetch(FetchDescriptor<PersistentTimer>()).first {
            persistentTimer.isRunning = false
            persistentTimer.startTime = nil
        }
        
        // TODO: Should be able to remove this
        try? modelContext.save()
        
        return .result()
    }
    
}
