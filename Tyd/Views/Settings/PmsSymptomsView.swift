//
//  PmsSymptomsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

import SwiftData
import SwiftUI

struct PmsSymptomsView: View {
    var symptoms: Binding<[String]>
    @State private var showingAlert: Bool = false
    @State private var newSymptomName: String = ""
    
    var body: some View {
        Form {
            Section {
                ForEach(symptoms.wrappedValue, id: \.self) { symptom in
                    Text(symptom)
                }
                .onDelete(perform: removeSymptoms)
            }
            
            Section {
                Button("Add Symptom") {
                    showingAlert.toggle()
                }
            }
        }
        .alert("Add Symptom", isPresented: $showingAlert, actions: {
            TextField("Add Symptom", text: $newSymptomName)
            
            Button("Add", action: {
                if !newSymptomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if !symptoms.wrappedValue.contains(newSymptomName) {
                        symptoms.wrappedValue.append(newSymptomName)
                        newSymptomName = ""
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {})
        })
    }
    
    func removeSymptoms(at offsets: IndexSet) {
        symptoms.wrappedValue.remove(atOffsets: offsets)
    }
}

#Preview {
    PmsSymptomsView(symptoms: .constant([]))
}
