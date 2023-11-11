//
//  SettingsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/10/23.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var appData: [AppData]
    @State private var showingResetAlert: Bool = false
    @State private var showingDeleteDataAlert: Bool = false
    @State private var deleteDataConfirmationText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    // TODO: Pro version allows user to customize accent color (and perhaps logo, etc.)
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
                            try modelContext.delete(model: Day.self)
                            modelContext.insert(Day(day: getTodaysDate()))
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
}

#Preview {
    SettingsView()
}
