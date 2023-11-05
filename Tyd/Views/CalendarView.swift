//
//  CalendarView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/5/23.
//

import SwiftData
import SwiftUI

struct CalendarView: View {
    @State var date: Date = .now
    @State var selectedDayData: Day = Day(day: getTodaysDate())
    @Query private var dayData: [Day]
    
    init() {
        updateSelectedDay()
    }

    var body: some View {
        Form {
            Section {
                DatePicker(
                    "Start Date",
                    selection: $date,
                    in: ...Date.now,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
            }
            
            Section {
                if !Calendar.current.isDateInToday(date) {
                    if !selectedDayData.pms {
                        Toggle("Period", isOn: $selectedDayData.period)
                            .tint(.accentColor)
                    }
                    if !selectedDayData.period {
                        Toggle("PMS", isOn: $selectedDayData.pms)
                            .tint(.accentColor)
                    }
                }
            }
            
            if selectedDayData.period || selectedDayData.pms {
                Section {
                    // Bleeding
                    if selectedDayData.period {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Bleeding")
                                Spacer()
                                Text("\(Int(selectedDayData.bleeding))")
                            }
                            Slider(
                                value: $selectedDayData.bleeding,
                                in: 0 ... 10,
                                step: 1.0
                            )
                        }
                    }
                    
                    // Pain
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Pain")
                            Spacer()
                            Text("\(Int(selectedDayData.pain))")
                        }
                        Slider(
                            value: $selectedDayData.pain,
                            in: 0 ... 10,
                            step: 1.0
                        )
                    }
                }
                
                // Symptoms
                
                // Medication
                
                //Notes
            }
        }
    }
    
    func updateSelectedDay() {
        let selectedDateString = dateFormatter.string(from: date)
        let predicate = #Predicate<Day> { day in
            day.day == selectedDateString
        }
        
        let data = try? dayData.filter(predicate)
        self.selectedDayData = data?.first ?? Day(day: getTodaysDate())
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: Day.self, inMemory: true)
}
