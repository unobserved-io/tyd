//
//  UnderCalendarView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/7/23.
//

import SwiftData
import SwiftUI

struct UnderCalendarView: View {
    @Query var dayData: [Day]
    let date: Date
    @Environment(\.modelContext) private var modelContext
    @State private var showAddMedSheet: Bool = false
    static var defaultUUID: UUID { UUID() }
    @State private var medicationPredicate: Predicate<Medication> = #Predicate<Medication> { medication in
        medication.id == defaultUUID
    }
    
    init(predicate: Predicate<Day>, date: Date) {
        _dayData = Query(filter: predicate)
        self.date = date
    }
    
    var body: some View {
        Section {
            if !(dayData.first?.pms ?? true) {
                Toggle("Period", isOn: Bindable(dayData.first ?? Day(day: getTodaysDate())).period)
                    .tint(.accentColor)
            }
            if !(dayData.first?.period ?? true) {
                Toggle("PMS", isOn: Bindable(dayData.first ?? Day(day: getTodaysDate())).pms)
                    .tint(.accentColor)
            }
            if dayData.first == nil {
                Text("No Data")
            }
        }
        .onAppear {
            checkForAndCreateDate()
        }
        .onChange(of: date) {
            checkForAndCreateDate()
        }
        .sheet(isPresented: $showAddMedSheet) {
                AddEditMedicationView(predicate: medicationPredicate)
                    .presentationDetents([.medicationInput])
        }
                    
        if dayData.first?.period ?? false || dayData.first?.pms ?? false {
            Section {
                // Bleeding
                if dayData.first?.period ?? false {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Bleeding")
                            Spacer()
                            Text("\(Int(dayData.first?.bleeding ?? 0.0))")
                        }
                        Slider(
                            value: Bindable(dayData.first ?? Day(day: getTodaysDate())).bleeding,
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
                        Text("\(Int(dayData.first?.pain ?? 0.0))")
                    }
                    Slider(
                        value: Bindable(dayData.first ?? Day(day: getTodaysDate())).pain,
                        in: 0 ... 10,
                        step: 1.0
                    )
                }
            }
                        
            // Symptoms
            Section {
                if dayData.first?.period ?? false {
                    MultiSelector(
                        label: String(localized: "Symptoms"),
                        options: ["symp1", "symp2"],
                        selected: Bindable(dayData.first ?? Day(day: getTodaysDate())).periodSymptoms
                    )
                } else {
                    MultiSelector(
                        label: String(localized: "Symptoms"),
                        options: ["symp1", "symp2"],
                        selected: Bindable(dayData.first ?? Day(day: getTodaysDate())).pmsSymptoms
                    )
                }
            }
                        
            // Medication
            Section {
                ForEach(dayData.first?.medication ?? []) { medication in
                    Text("\(timeFormatter.string(from: medication.time)) - \(medication.dose) \(medication.name)")
                }
                Button("Add medication") {
                    let newMedication = Medication()
                    modelContext.insert(newMedication)
                    dayData.first?.medication?.append(newMedication)
                    let newUUID = newMedication.id
                    medicationPredicate = #Predicate<Medication> { medication in
                        medication.id == newUUID
                    }
                    showAddMedSheet.toggle()
                }
            }
                        
            // Notes
            Section {
                TextField("Notes", text: Bindable(dayData.first ?? Day(day: getTodaysDate())).notes, axis: .vertical)
            }
        }
    }
    
    func checkForAndCreateDate() {
        DispatchQueue.main.async {
            if dayData.first == nil {
                modelContext.insert(Day(day: dateFormatter.string(from: date)))
            }
        }
    }
}

// #Preview {
//    UnderCalendarView()
// }
