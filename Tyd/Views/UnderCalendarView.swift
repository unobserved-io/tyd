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
//            print("\(dateFormatter.string(from: date)) APPEARED")
            checkForAndCreateDate()
        }
        .onChange(of: date) {
//            print("\(dateFormatter.string(from: date)) CHANGED")
            checkForAndCreateDate()
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
            //            Section {
            //                // Med drop down from meds list
            //                //                        for medication in selectedDayData.medication {
            //                //
            //                //                        }
            //                Button("Add medication") {
            //                    clickedMedication.medication = Medication()
            //                    showAddMedSheet.toggle()
            //                }
            //            }
                        
            // Notes
            Section {
                TextField("Notes", text: Bindable(dayData.first ?? Day(day: getTodaysDate())).notes, axis: .vertical)
            }
        }
    }
    
    func checkForAndCreateDate() {
        DispatchQueue.main.async {
//            print("CHECKED")
            if dayData.first == nil {
                modelContext.insert(Day(day: dateFormatter.string(from: date)))
//                print("CREATED")
            }
        }
    }
}

// #Preview {
//    UnderCalendarView()
// }
