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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Binding var dayData: DayData
    @Query var appData: [AppData]
    @State private var showingEditMedSheet: Bool = false
    static var defaultUUID: UUID { UUID() }
    @State private var tappedMedication: Medication = .init()
    
    var body: some View {
        // Period or PMS
        Section {
            if !dayData.pms {
                Toggle("Period", isOn: $dayData.period)
                    .tint(.accentColor)
            }
            if !dayData.period {
                Toggle("PMS", isOn: $dayData.pms)
                    .tint(.accentColor)
            }
        }
        
        Section {
            // Bleeding
            if dayData.period {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Bleeding")
                        Spacer()
                        Text("\(Int(dayData.bleeding))")
                    }
                    Slider(
                        value: $dayData.bleeding,
                        in: 0 ... 10,
                        step: 1.0
                    )
                }
            }
                            
            // Pain
            if dayData.period || dayData.pms {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Pain")
                        Spacer()
                        Text("\(Int(dayData.pain))")
                    }
                    Slider(
                        value: $dayData.pain,
                        in: 0 ... 10,
                        step: 1.0
                    )
                }
            }
        }
                        
        // Symptoms
        Section {
            if dayData.period {
                MultiSelector(
                    label: String(localized: "Symptoms"),
                    options: removeDuplicates(from: defaultPeriodSymptoms + (appData.first?.periodSymptoms ?? []) + dayData.periodSymptoms),
                    selected: $dayData.periodSymptoms
                )
            } else if dayData.pms {
                MultiSelector(
                    label: String(localized: "Symptoms"),
                    options: removeDuplicates(from: defaultPmsSymptoms + (appData.first?.pmsSymptoms ?? []) + dayData.pmsSymptoms),
                    selected: $dayData.pmsSymptoms
                )
            }
        }
                        
        // Medication
        Section(dayData.medication?.isEmpty ?? true ? "" : "MEDICATION") {
            ForEach(dayData.medication ?? []) { medication in
                Button {
                    tappedMedication = medication
                    showingEditMedSheet.toggle()
                } label: {
                    Text("\(medication.time.formatted(date: .omitted, time: .shortened)) - \(medication.dose) \(medication.name)")
                }
            }
            .onDelete(perform: deleteMedication)
                
            Button("Add medication") {
                let newMedication = Medication()
                modelContext.insert(newMedication)
                dayData.medication?.append(newMedication)
                tappedMedication = newMedication
                showingEditMedSheet.toggle()
            }
        }
        .sheet(isPresented: $showingEditMedSheet) {
            AddEditMedicationView(medication: $tappedMedication)
                .presentationDetents(dynamicTypeSize <= .xxLarge ? [.small] : [])
        }
                        
        // Notes
        Section(dayData.notes.isEmpty ? "" : "NOTES") {
            TextField("Notes", text: $dayData.notes, axis: .vertical)
        }
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        offsets.forEach { index in
            let medToDelete: Medication? = dayData.medication?[index]
            if medToDelete != nil {
                dayData.medication?.remove(at: index)
                modelContext.delete(medToDelete!)
            }
        }
    }
    
    private func removeDuplicates(from symptomList: [String]) -> [String] {
        return Array(Set(symptomList))
    }
}

#Preview {
    UnderCalendarView(dayData: .constant(DayData(day: "2023.31.12")))
}
