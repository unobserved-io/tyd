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
    @State private var date: Date = .now
    @State private var currentDay: DayData = .init(day: "06.08.1927")

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
                    .onChange(of: date) { _, newDate in
                        getDayData(date: newDate)
                    }
                }

                if currentDay.day != "06.08.1927" {
                    UnderCalendarView(dayData: $currentDay)
                }
            }
            .onAppear {
                getDayData(date: date)
            }
            .navigationBarTitle("History")
        }
    }

    private func getDayData(date: Date) {
        let dateString = dateFormatter.string(from: date)
        let fetchDescriptor = FetchDescriptor<DayData>(predicate: #Predicate<DayData> { day in
            day.day == dateString
        })
        do {
            var fetchedDay = try modelContext.fetch(fetchDescriptor)
            if fetchedDay.first == nil {
                createAndAssignDayData(dateString: dateString)
                fetchedDay = try modelContext.fetch(fetchDescriptor)
            }
            currentDay = fetchedDay.first ?? DayData(day: "06.08.1927")
        } catch {
            print("Failed to load day data.")
        }
    }

    private func createAndAssignDayData(dateString: String) {
        let newDayData = DayData(day: dateString)
        modelContext.insert(newDayData)
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: DayData.self, inMemory: true)
}
