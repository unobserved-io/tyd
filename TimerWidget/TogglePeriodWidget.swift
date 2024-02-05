//
//  TogglePeriodWidget.swift
//  TimerWidget
//
//  Created by Ricky Kresslein on 12/23/23.
//

import SwiftData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    @MainActor
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), dayData: getDayData(), dayNumber: getDayNumber())
    }

    @MainActor
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), dayData: getDayData(), dayNumber: getDayNumber())
        completion(entry)
    }

    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: .now, dayData: getDayData(), dayNumber: getDayNumber())], policy: .atEnd)
        // Old policy: .after(.now.advanced(by: 60 * 5)) // (for every five minutes)
        completion(timeline)
    }
    
    @MainActor
    private func getDayData() -> DayData? {
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
            return nil
        }
        
        return dayData
    }
    
    private func getDayNumber() -> Int {
        updateStats()
        return Stats.shared.daysSinceLastPeriod
    }
    
    private func updateStats() {
        var today: String {
            let dateFormatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter
            }()
            return dateFormatter.string(from: Date.now)
        }

        let modelContext = ModelContext(DayData.container)
        let dayData = try! modelContext.fetch(
            FetchDescriptor<DayData>()
        )
                
        Stats.shared.updateAllStats(from: dayData)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let dayData: DayData?
    let dayNumber: Int
}

struct TogglePeriodWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Button(intent: TogglePeriodIntent()) {
                Image("Tyd100")
                    .foregroundStyle(.accent)
                    .opacity(entry.dayData?.period ?? false ? 1.0 : 0.3)
            }
            .buttonStyle(.plain)
            
            if entry.dayNumber > 0 {
                Text("DAY \(entry.dayNumber)")
                    .bold()
            }
        }
        .padding()
    }
}

struct TogglePeriodWidget: Widget {
    let kind: String = "TogglePeriodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TogglePeriodWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Tyd Period")
        .description("Display and toggle your period.")
        .supportedFamilies([.systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    TimerWidget()
//} timeline: {
//    SimpleEntry(date: .now, dayData: nil, dayNumber: 0)
//    SimpleEntry(date: .now, dayData: nil, dayNumber: 0)
//}
