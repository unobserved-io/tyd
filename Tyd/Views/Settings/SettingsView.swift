//
//  SettingsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/10/23.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Query var appData: [AppData]
    
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
                    
                }
                
                Section("Info") {
                    
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
