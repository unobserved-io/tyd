//
//  CalendarView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/5/23.
//

import SwiftData
import SwiftUI

struct TestView: View {
    @Environment(\.modelContext) private var modelContext
    static var today: String { getTodaysDate() }
    @State private var date: Date = .now
    @State private var datePredicate: Predicate<Day> = #Predicate<Day> { day in
        day.day == today
    }
    @State var testInt = 2
//    @State var selectedDayData: Day = .init(day: getTodaysDate())
//    @Query private var dayData: [Day]
//    @Query private var appData: [AppData]
//    @State private var showAddMedSheet: Bool = false
//    @StateObject var clickedMedication = ClickedMedication(nil)

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
                        datePredicate = #Predicate<Day> { day in
                            day.day == dateString
                        }
                    }
                }
                
                UnderCalendarView(predicate: datePredicate, date: date)
            }
        }
    }
    
//    func addDateToModel() {
//        modelContext.insert(Day(day: dateFormatter.string(from: date)))
//    }
    
//    func updatePredicate() {
//        let dateString = dateFormatter.string(from: date)
//        datePredicate = #Predicate<Day> { day in
//            day.day == dateString
//        }
//    }
}

#Preview {
    TestView()
        .modelContainer(for: Day.self, inMemory: true)
}
