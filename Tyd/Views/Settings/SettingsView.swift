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
    
    var body: some View {
        NavigationStack {
            Form {
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
                    
                }
                
                Section("Danger Zone") {
                    Button("Reset All Settings") {
                        showingResetAlert.toggle()
                    }
                }
                .alert("Reset all settings to default?", isPresented: $showingResetAlert, actions: {                  
                    Button("Reset", action: {
                        if appData.first != nil {
                            modelContext.delete(appData.first!)
                            modelContext.insert(AppData())
                        }
                    })
                    Button("Cancel", role: .cancel, action: {})
                })
                
                Section("Info") {
                    
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
