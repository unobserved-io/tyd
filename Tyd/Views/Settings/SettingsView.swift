//
//  SettingsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/10/23.
//

import StoreKit
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
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @Environment(\.passIDs) private var passIDs
    
    @Query var appData: [AppData]
    @Query var dayData: [DayData]
    
    @AppStorage("showLiveActivity") var showLiveActivity: Bool = false
    @AppStorage("chosenIcon") var chosenIcon: String = AppIcons.primary.rawValue
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    
    @ObservedObject var storeModel = StoreModel.shared
    
    @State private var status: EntitlementTaskState<PassStatus> = .loading
    @State private var showingResetAlert: Bool = false
    @State private var showingDeleteDataAlert: Bool = false
    @State private var showingImportSuccessAlert: Bool = false
    @State private var showingImportFailedAlert: Bool = false
    @State private var showingPurchaseAlert: Bool = false
    @State private var deleteDataConfirmationText: String = ""
    @State private var showingDataImporter: Bool = false
    @State private var showingDataExporter: Bool = false
    @State private var showingImportWarning: Bool = false
    @State private var showingAboutSheet: Bool = false
//    @State private var showingPurchaseSheet: Bool = false
    @State private var showingManageSubscriptionSheet: Bool = false
    
    var timerHelper = TimerHelper.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    if passStatusModel.passStatus == .notSubscribed && storeModel.purchasedIds.isEmpty {
                        Button {
                            showingPurchaseAlert.toggle()
                        } label: {
                            Label {
                                HStack {
                                    Text("App Color")
                                        .foregroundColor(.primary)
                                        .badge("Tyd+")
                                }
                            } icon: {
                                Image(systemName: "paintpalette.fill")
                            }
                        }
                    } else {
                        NavigationLink(destination: AccentColorPickerView()) {
                            Label("App Color", systemImage: "paintpalette.fill")
                        }
                    }
                    
                    if passStatusModel.passStatus == .notSubscribed && storeModel.purchasedIds.isEmpty {
                        Button {
                            showingPurchaseAlert.toggle()
                        } label: {
                            Label {
                                HStack {
                                    Text("App Icon")
                                        .foregroundColor(.primary)
                                        .badge("Tyd+")
                                }
                            } icon: {
                                Image(systemName: "app.gift.fill")
                            }
                        }
                    } else {
                        NavigationLink(destination: AppIconPickerView()) {
                            Label("App Icon", systemImage: "app.gift.fill")
                        }
                    }
                }
//                .sheet(isPresented: $showingPurchaseSheet) {
//                    PaywallSubscription()
//                }
                
                Section("Symptoms & Meds") {
                    NavigationLink(destination: AdditionalSymptomsView(symptoms: Bindable(appData.first ?? AppData()).periodSymptoms)) {
                        Text("Additional Period Symptoms")
                    }
                    NavigationLink(destination: AdditionalSymptomsView(symptoms: Bindable(appData.first ?? AppData()).pmsSymptoms)) {
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
                    Toggle(isOn: $showLiveActivity) {
                        HStack {
                            Text("Live Activity Widget")
                                .badge(passStatusModel.passStatus == .notSubscribed && storeModel.purchasedIds.isEmpty ? "Tyd+" : nil)
                        }
                    }
                    .disabled(passStatusModel.passStatus == .notSubscribed && storeModel.purchasedIds.isEmpty)
                    .onChange(of: showLiveActivity) { _, newValue in
                        if timerHelper.isRunning {
                            if newValue {
                                timerHelper.startLiveActivity()
                            } else {
                                Task {
                                    await timerHelper.stopLiveActivity()
                                }

                            }
                        }
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
                                    showingImportSuccessAlert.toggle()
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
                                                newDay.medication?.append(newMedication)
                                            }
                                        }
                                        for medication in tDayData.pmsMedsTaken {
                                            if medication.count == 3 {
                                                let newMedication: Medication = .init()
                                                newMedication.name = medication[0]
                                                newMedication.time = dateFormatter.date(from: newDay.day) ?? .distantPast
                                                newMedication.dose = medication[2]
                                                modelContext.insert(newMedication)
                                                newDay.medication?.append(newMedication)
                                            }
                                        }
                                        
                                        modelContext.insert(newDay)
                                    }
                                    showingImportSuccessAlert.toggle()
                                } else {
                                    showingImportFailedAlert.toggle()
                                }
                            }
                            fileURL.stopAccessingSecurityScopedResource()
                        } catch {
                            showingImportFailedAlert.toggle()
                            print("Failed to import data: \(error.localizedDescription)")
                        }
                    }
                }
                
                Section("Danger Zone") {
                    Button("Reset All Settings") {
                        showingResetAlert.toggle()
                    }
                    .foregroundStyle(.primary)
                    Button("Delete All Data") {
                        showingDeleteDataAlert.toggle()
                    }
                    .foregroundStyle(.primary)
                }
                
                Section("More") {
                    Button("About") {
                        showingAboutSheet.toggle()
                    }
                    .foregroundStyle(.primary)
                    
                    if passStatusModel.passStatus == .notSubscribed && storeModel.purchasedIds.isEmpty {
                        Button {
                            showingPurchaseAlert.toggle()
                        } label: {
                            HStack {
                                Text("Purchase Tyd+")
                                    .foregroundColor(.accent)
                            }
                        }
                    } 
                    if passStatusModel.passStatus != .notSubscribed {
                        Button {
                            showingManageSubscriptionSheet.toggle()
                        } label: {
                            HStack {
                                Text("Manage Subscription")
                                    .foregroundColor(.accent)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
        .onAppear {
            Task {
                try await storeModel.fetchProducts()
            }
        }
//        .manageSubscriptionsSheet(
//           isPresented: $showingManageSubscriptionSheet,
//           subscriptionGroupID: passIDs.group
//       )
        .sheet(isPresented: $showingAboutSheet) {
            AboutView()
        }
        .alert("Delete all data?", isPresented: $showingImportWarning) {
            Button("Import") {
                showingDataImporter.toggle()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Importing data will delete all current data. Do you still want to import?")
        }
        .alert("Success", isPresented: $showingImportSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Data successfully imported")
        }
        .alert("Failed", isPresented: $showingImportFailedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The file you selected cannot be imported")
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
        .alert("Get Tyd+?", isPresented: $showingPurchaseAlert) {
            if let product = storeModel.products.first {
                Button("Upgrade (\(product.displayPrice))") {
                    Task {
                        try await storeModel.purchase()
                    }
                }
                Button("Restore purchase") {
                    Task {
                        try await AppStore.sync()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This feature is only availble in Tyd+. Upgrade now to access it.")
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
    
    private func resetPaywalledFeatures() {
        showLiveActivity = false
        tydAccentColor = "8B8BB0FF"
        chosenIcon = AppIcons.primary.rawValue
        UIApplication.shared.setAlternateIconName(chosenIcon)
    }
}

#Preview {
    SettingsView()
}
