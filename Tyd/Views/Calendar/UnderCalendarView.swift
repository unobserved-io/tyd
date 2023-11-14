//
//  UnderCalendarView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/7/23.
//

import SwiftData
import SwiftUI

struct UnderCalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appData: [AppData]
    @Query var dayData: [Day]
    let date: Date
    @State private var showingEditMedSheet: Bool = false
    static var defaultUUID: UUID { UUID() }
    @State private var tappedMedication: Medication = .init()
    
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
        .sheet(isPresented: $showingEditMedSheet) {
            AddEditMedicationView(medication: $tappedMedication)
                .presentationDetents([.small])
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
                        options: defaultPeriodSymptoms + (appData.first?.periodSymptoms ?? []),
                        selected: Bindable(dayData.first ?? Day(day: getTodaysDate())).periodSymptoms
                    )
                } else {
                    MultiSelector(
                        label: String(localized: "Symptoms"),
                        options: defaultPmsSymptoms + (appData.first?.pmsSymptoms ?? []),
                        selected: Bindable(dayData.first ?? Day(day: getTodaysDate())).pmsSymptoms
                    )
                }
            }
                        
            // Medication
            Section((dayData.first?.medication.isEmpty ?? true) ? "" : "MEDICATION") {
                ForEach(dayData.first?.medication ?? []) { medication in
                    Button {
                        tappedMedication = medication
                        showingEditMedSheet.toggle()
                    } label: {
                        Text("\(timeFormatter.string(from: medication.time)) - \(medication.dose) \(medication.name)")
                    }
                }
                .onDelete(perform: deleteMedication)
                
                Button("Add medication") {
                    let newMedication = Medication()
                    modelContext.insert(newMedication)
                    dayData.first?.medication.append(newMedication)
                    tappedMedication = newMedication
                    showingEditMedSheet.toggle()
                }
            }
                        
            // Notes
            Section((dayData.first?.notes.isEmpty ?? true) ? "" : "NOTES") {
                TextField("Notes", text: Bindable(dayData.first ?? Day(day: getTodaysDate())).notes, axis: .vertical)
            }
        }
    }
    
    private func checkForAndCreateDate() {
        DispatchQueue.main.async {
            if dayData.first == nil {
                modelContext.insert(Day(day: dateFormatter.string(from: date)))
            }
        }
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        let index = offsets.first
        if index != nil {
            let medToDelete: Medication? = dayData.first?.medication[index!]
            if medToDelete != nil {
                dayData.first?.medication.remove(at: index!)
                modelContext.delete(medToDelete!)
            }
        }
    }
}

// #Preview {
//    UnderCalendarView()
// }
