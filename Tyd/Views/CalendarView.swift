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
    @State var date: Date = .now
    @State var selectedDayData: Day = .init(day: getTodaysDate())
    @Query private var dayData: [Day]
    @Query private var appData: [AppData]
    @State private var showAddMedSheet: Bool = false
    @StateObject var clickedMedication = ClickedMedication(nil)
    
    init() {
        updateSelectedDay()
        if appData.isEmpty {
            // TODO: Create new AppData value
        }
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
                    Section {
                        if selectedDayData.period {
                            MultiSelector(
                                label: String(localized: "Symptoms"),
                                options: ["symp1", "symp2"],
                                selected: $selectedDayData.periodSymptoms
                            )
                        } else {
                            MultiSelector(
                                label: String(localized: "Symptoms"),
                                options: ["symp1", "symp2"],
                                selected: $selectedDayData.pmsSymptoms
                            )
                        }
                    }
                    
                    // Medication
                    Section {
                        // Med drop down from meds list
//                        for medication in selectedDayData.medication {
//
//                        }
                        Button("Add medication") {
                            clickedMedication.medication = Medication()
                            showAddMedSheet.toggle()
                        }
                    }
                    
                    // Notes
                    Section {
                        TextField("Notes", text: $selectedDayData.notes, axis: .vertical)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddMedSheet) {
            if clickedMedication.medication != nil {
                AddEditMedicationView()
                    .environmentObject(clickedMedication)
                    .navigationTitle("Add Medication")
                    .presentationDetents([.medium])
            }
        }
    }
    
    func updateSelectedDay() {
        let selectedDateString = dateFormatter.string(from: date)
        let predicate = #Predicate<Day> { day in
            day.day == selectedDateString
        }
        
        let data = try? dayData.filter(predicate)
        selectedDayData = data?.first ?? Day(day: getTodaysDate())
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: Day.self, inMemory: true)
}
