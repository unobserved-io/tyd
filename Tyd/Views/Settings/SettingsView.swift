//
//  SettingsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/10/23.
//

import SwiftData
import SwiftUI
// import UniformTypeIdentifiers

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

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var storeModel = StoreModel.sharedInstance
    @Query var appData: [AppData]
    @Query var dayData: [DayData]
    @State private var showingResetAlert: Bool = false
    @State private var showingDeleteDataAlert: Bool = false
    @State private var deleteDataConfirmationText: String = ""
    @State private var showingDataImporter: Bool = false
    @State private var showingDataExporter: Bool = false
    @State private var showingImportWarning: Bool = false
    @State private var showingAboutSheet: Bool = false
    @State private var showingPurchaseSheet: Bool = false
//    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    if storeModel.purchasedIds.isEmpty {
                        Button {
                            showingPurchaseSheet.toggle()
                        } label: {
                            Label {
                                Text("App Color (Pro)")
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "paintpalette.fill")
                            }
                        }
                    } else {
                        NavigationLink(destination: AccentColorPickerView()) {
                            Label("App Color", systemImage: "paintpalette.fill")
                        }
                    }
                }
                .sheet(isPresented: $showingPurchaseSheet) {
                    PaywallSubscription()
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
                    // Export data
                    Button {
                        showingDataExporter.toggle()
                    } label: {
                        Label {
                            Text("Export Data")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.up.fill")
                        }
                    }
                    .fileExporter(
                        isPresented: $showingDataExporter,
                        document: JSONDocument(data: getDayDataAsJSON() ?? "[]".data(using: .utf8)!),
                        contentType: .json,
                        defaultFilename: "Tyd-\(dateFormatter.string(from: Date.now))"
                    ) { _ in }
                    
                    // TODO: Import data from Clue
                    // Import Data
                    Button {
                        if dayData.count > 1 {
                            showingImportWarning.toggle()
                        } else {
                            showingDataImporter.toggle()
                        }
                    } label: {
                        Label {
                            Text("Import Data")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "square.and.arrow.down.fill")
                        }
                    }
                    .fileImporter(isPresented: $showingDataImporter, allowedContentTypes: [.json]) { result in
                        do {
                            let fileURL = try result.get()
                            if fileURL.startAccessingSecurityScopedResource() {
                                let fileData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                                // First try to decode as standard data, then else if decode as legacy data
                                if let allDayData = try? JSONDecoder().decode([DayData].self, from: fileData) {
                                    deleteAllDayData()
                                    
                                    for tDayData in allDayData {
                                        modelContext.insert(tDayData)
                                    }
                                } else if let allDayData = try? JSONDecoder().decode(OldData.self, from: fileData) {
                                    deleteAllDayData()
                                    
                                    for tDayData in allDayData.data {
                                        // Check if the day being imported already exists
                                        if let duplicateData = dayData.first(where: { $0.day == tDayData.date }) {
                                            modelContext.delete(duplicateData)
                                        }
                                        let newDay: DayData = .init(day: tDayData.date)
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
                                                let newMedication: Medication = .init()
                                                newMedication.name = medication[0]
                                                newMedication.time = dateFormatter.date(from: newDay.day) ?? .distantPast
                                                newMedication.dose = medication[2]
                                                modelContext.insert(newMedication)
                                                newDay.medication.append(newMedication)
                                            }
                                        }
                                        for medication in tDayData.pmsMedsTaken {
                                            if medication.count == 3 {
                                                let newMedication: Medication = .init()
                                                newMedication.name = medication[0]
                                                newMedication.time = dateFormatter.date(from: newDay.day) ?? .distantPast
                                                newMedication.dose = medication[2]
                                                modelContext.insert(newMedication)
                                                newDay.medication.append(newMedication)
                                            }
                                        }
                                        
                                        modelContext.insert(newDay)
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
                .alert("Delete all data?", isPresented: $showingImportWarning) {
                    Button("Import") {
                        showingDataImporter.toggle()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Importing data will delete all current data. Do you still want to import?")
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
                    Button("About") {
                        showingAboutSheet.toggle()
                    }
                }
                .sheet(isPresented: $showingAboutSheet) {
                    AboutView()
                }
            }
            .navigationBarTitle("Settings")
//            .navigationDestination(for: String.self) { view in
//                if view == "AccentColorPickerView" {
//                    AccentColorPickerView()
//                }
//            }
        }
    }
    
    private func deleteAllDayData() {
        do {
            try modelContext.delete(model: DayData.self)
        } catch {
            print("Failed to delete all DayData.")
        }
    }
    
    private func getDayDataAsJSON() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(dayData.sorted(by: { $0.day < $1.day }))
    }
}

#Preview {
    SettingsView()
}
