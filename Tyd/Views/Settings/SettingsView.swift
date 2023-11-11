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
                    Text("Period Symptoms")
                    Text("PMS Symptoms")
                    NavigationLink(destination: MedicinesView(medicines: Bindable(appData.first ?? AppData()).medicines)) {
                        Text("Medicines")
                    }
                }
                
                Section("Timer") {
                    
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
