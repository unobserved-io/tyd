//
//  TimerWidget.swift
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
        SimpleEntry(date: Date(), dayData: getDayData())
    }

    @MainActor
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), dayData: getDayData())
        completion(entry)
    }

    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: .now, dayData: getDayData())], policy: .after(.now.advanced(by: 60 * 5)))
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
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let dayData: DayData?
}

struct TimerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // TODO: I should be able to get the Day by making Stats a shared singleton
        // TODO: Then calling the function just like getDayData to update the stats and get the day
        Button(intent: TogglePeriodIntent()) {
            Image("TydLogo")
                .foregroundStyle(.accent)
                .opacity(entry.dayData?.period ?? false ? 1.0 : 0.3)
        }
        .buttonStyle(.plain)
    }
}

struct TimerWidget: Widget {
    let kind: String = "TimerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimerWidgetEntryView(entry: entry)
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
//    SimpleEntry(date: .now, dayData: nil)
//    SimpleEntry(date: .now, dayData: nil)
//}
