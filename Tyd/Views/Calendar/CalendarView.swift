//
//  CalendarView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/5/23.
//

import SwiftData
import SwiftUI

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    static var today: String { getTodaysDate() }
    @State private var date: Date = .now
    @State private var datePredicate: Predicate<DayData> = #Predicate<DayData> { day in
        day.day == today
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        "Start Date",
                        selection: $date,
                        in: ...Date.now,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .onChange(of: date) { oldDate, newDate in
                        let dateString = dateFormatter.string(from: newDate)
                        datePredicate = #Predicate<DayData> { day in
                            day.day == dateString
                        }
                    }
                }
                
                UnderCalendarView(predicate: datePredicate, date: date)
            }
        }
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: DayData.self, inMemory: true)
}
