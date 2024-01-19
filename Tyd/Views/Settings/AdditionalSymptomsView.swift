//
//  PeriodSymptomsView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

import SwiftData
import SwiftUI

struct AdditionalSymptomsView: View {
    var symptoms: Binding<[String]>
    @State private var showingAddAlert: Bool = false
    @State private var showingEditAlert: Bool = false
    @State private var newSymptomName: String = ""
    @State private var symptomToChange: String = ""
    
    var body: some View {
        Form {
            Section {
                ForEach(symptoms.wrappedValue, id: \.self) { symptom in
                    Text(symptom)
                        .swipeActions(edge: .leading) {
                            Button {
                                symptomToChange = symptom
                                newSymptomName = symptom
                                showingEditAlert.toggle()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                }
                .onDelete(perform: removeSymptoms)
            }
            
            Section {
                Button("Add Symptom") {
                    showingAddAlert.toggle()
                }
            }
        }
        .alert("Add Symptom", isPresented: $showingAddAlert, actions: {
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
        .alert("Edit Symptom", isPresented: $showingEditAlert, actions: {
            TextField(symptomToChange, text: $newSymptomName)
            
            Button("Save", action: {
                if !newSymptomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if newSymptomName != symptomToChange, !symptoms.wrappedValue.contains(newSymptomName) {
                        if let indexOfSymptom = symptoms.wrappedValue.firstIndex(of: symptomToChange) {
                            symptoms.wrappedValue[indexOfSymptom] = newSymptomName
                        }
                    }
                }
                newSymptomName = ""
            })
            Button("Cancel", role: .cancel, action: { newSymptomName = "" })
        })
    }
    
    func removeSymptoms(at offsets: IndexSet) {
        symptoms.wrappedValue.remove(atOffsets: offsets)
    }
}

#Preview {
    AdditionalSymptomsView(symptoms: .constant([]))
}
