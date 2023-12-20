//
//  SettingsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/10/23.
//

import SwiftData
import SwiftUI

struct OldData: Decodable {
    var data: [OldDayData]
    var settings: OldSettings
    var environment: OldEnvironment
}

struct OldDayData: Decodable {
    var date: String
    var period: Bool
    var pms: Bool
    var bleeding: Double
    var pain: Double
    var periodSymptoms: Set<String>
    var periodMedsTaken: [[String]]
    var periodNotes: String
    var pmsSymptoms: Set<String>
    var pmsMedsTaken: [[String]]
    var pmsNotes: String
}

//"periodMedsTaken": [
//       [
//         "Aspirin",
//         "5:00",
//         "20mg"
//       ]
//     ],

struct OldSettings: Decodable {
    var medicines: Set<String>
    var periodSymptoms: [String]
    var pmsSymptoms: [String]
    var sanitaryTypes: [String: Double]
    var tamponSizes: [String]
}

struct OldEnvironment: Decodable {
    var application_id: String
}

//"settings": {
//    "medicines": [
//      "Aspirin",
//      "Ibuprofen",
//      "Paracetamol",
//      "Acetaminophen"
//    ],
//    "periodSymptoms": [
//      "Anxious",
//      "Back pain",
//      "Bloating",
//      "Breast tenderness",
//      "Constipation",
//      "Cramps",
//      "Diarrhea",
//      "Fatigue",
//      "Headache",
//      "Insomnia",
//      "Irritable",
//      "Joint pain",
//      "Muscle aches",
//      "Nausea",
//      "Painful defecation",
//      "Pimples"
//    ],
//    "pmsSymptoms": [
//      "Anger",
//      "Anxious",
//      "Back pain",
//      "Bloating",
//      "Breast tenderness",
//      "Changed appetite",
//      "Changed sex drive",
//      "Constipation",
//      "Cramps",
//      "Diarrhea",
//      "Dizziness",
//      "Fatigue",
//      "Headache",
//      "Insomnia",
//      "Irritable",
//      "Joint pain",
//      "Muscle aches",
//      "Nausea",
//      "Painful defecation",
//      "Pimples",
//      "Sadness"
//    ],
//    "sanitaryTypes": {
//      "Tampon": 4.0,
//      "Pad": 4.0,
//      "Cup": 4.0,
//      "Underwear": 4.0
//    },
//    "tamponSizes": [
//      "-",
//      "Light",
//      "Regular",
//      "Super",
//      "Super Plus",
//      "Ultra"
//    ]
//  },
//  "environment": {
//    "application_id": "com.lakoliu.tyd"
//  }
//}

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appData: [AppData]
    @Query var dayData: [DayData]
    @State private var showingResetAlert: Bool = false
    @State private var showingDeleteDataAlert: Bool = false
    @State private var deleteDataConfirmationText: String = ""
    @State private var showingDataImportFilePicker: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    NavigationLink(destination: AccentColorPickerView()) {
                        Text("App Color")
                    }
                }
                
                Section("Symptoms & Meds") {
                    NavigationLink(destination: PmsSymptomsView(symptoms: Bindable(appData.first ?? AppData()).periodSymptoms)) {
                        Text("Additional Period Symptoms")
                    }
                    NavigationLink(destination: PmsSymptomsView(symptoms: Bindable(appData.first ?? AppData()).pmsSymptoms)) {
                        Text("Additional PMS Symptoms")
                    }
                    NavigationLink(destination: MedicinesView(medicines: Bindable(appData.first ?? AppData()).medicines)) {
                        Text("Medicines")
                    }
                }
                
                Section("Timer") {
                    NavigationLink(destination: TimerIntervalsView(intervals: Bindable(appData.first ?? AppData()).timerIntervals)) {
                        Text("Intervals")
                    }
                }
                
                Section("Saved Data") {
                    // TODO: Import data from Tyd or Clue
                    // TODO: Export data
                    // Import Data
                    Button {
                        showingDataImportFilePicker.toggle()
                        // TODO: Show warning dialog
//                        if dayData.count > 1 {
//                            showingDayImportAlert.toggle()
//                        } else {
//                            showingDayFilePicker.toggle()
//                        }
                    } label: {
                        Label {
                            Text("Import Data")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.down.fill")
                        }
                    }
                    .fileImporter(isPresented: $showingDataImportFilePicker, allowedContentTypes: [.json]) { result in
                        do {
                            let fileURL = try result.get()
                            if fileURL.startAccessingSecurityScopedResource() {
                                let fileData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                                // TODO: First try to decode as standard data, then else if decode as legacy data
                                if let allDayData = try? JSONDecoder().decode(OldData.self, from: fileData) {
                                    // First, delete all current data
                                    deleteAllDayData()

                                    // Variables to check for today in imported data
                                    let todayString: String = dateFormatter.string(from: .now)
                                    var todayFound = false
                                    
                                    for tDayData in allDayData.data {
                                        // Check if the day being imported already exists
                                        if let duplicateData = dayData.first(where: { $0.day == tDayData.date }) {
                                            modelContext.delete(duplicateData)
                                        }
                                        let newDay: DayData = DayData(day: tDayData.date)
                                        // Check for today in imported data
                                        if newDay.day == todayString {
                                            todayFound = true
                                        }
                                        newDay.period = tDayData.period
                                        newDay.pms = tDayData.pms
                                        newDay.bleeding = tDayData.bleeding * 10
                                        newDay.pain = tDayData.pain * 10
                                        newDay.notes = tDayData.periodNotes
                                        if !tDayData.pmsNotes.isEmpty {
                                            newDay.notes += (newDay.notes.isEmpty ? "" : " ") + tDayData.pmsNotes
                                        }
                                        newDay.periodSymptoms = tDayData.periodSymptoms
                                        newDay.pmsSymptoms = tDayData.pmsSymptoms
                                        for medication in tDayData.periodMedsTaken {
                                            if medication.count == 3 {
                                                let newMedication: Medication = Medication()
                                                newMedication.name = medication[0]
                                                newMedication.time = dateFormatter.date(from: newDay.day) ?? .distantPast
                                                newMedication.dose = medication[2]
                                                modelContext.insert(newMedication)
                                                newDay.medication.append(newMedication)
                                            }
                                        }
                                        for medication in tDayData.pmsMedsTaken {
                                            if medication.count == 3 {
                                                let newMedication: Medication = Medication()
                                                newMedication.name = medication[0]
                                                newMedication.time = dateFormatter.date(from: newDay.day) ?? .distantPast
                                                newMedication.dose = medication[2]
                                                modelContext.insert(newMedication)
                                                newDay.medication.append(newMedication)
                                            }
                                        }
                                        
                                        modelContext.insert(newDay)
                                    }
                                    
                                    // Reload app if today is not found to build it
                                    if !todayFound {
                                        // TODO: Create a "today" item
                                    }
                                } else {
                                    print("Data import failed")
                                }
                            }
                            fileURL.stopAccessingSecurityScopedResource()
                        } catch {
                            print("Failed to import data: \(error.localizedDescription)")
                        }
                    }
                }
                
                Section("Danger Zone") {
                    Button("Reset All Settings") {
                        showingResetAlert.toggle()
                    }
                    Button("Delete All Data") {
                        showingDeleteDataAlert.toggle()
                    }
                }
                .alert("Reset settings?", isPresented: $showingResetAlert) {
                    Button("Reset") {
                        do {
                            try modelContext.delete(model: AppData.self)
                            modelContext.insert(AppData())
                        } catch {}
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to reset all settings to their defaults?")
                }
                .alert("Delete all data?", isPresented: $showingDeleteDataAlert) {
                    Button("Reset") {
                        do {
                            try modelContext.delete(model: DayData.self)
                            modelContext.insert(DayData(day: getTodaysDate()))
                        } catch {}
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to erase all of your data? This is irreversible.")
                }
                
                Section("Info") {
                    // TODO: About Tyd page? (Is this allowed by Apple if it includes email?)
                }
            }
        }
    }
    
    private func deleteAllDayData() {
        do {
            try modelContext.delete(model: DayData.self)
        } catch {
            print("Failed to delete all DayData.")
        }
    }
}

#Preview {
    SettingsView()
}
