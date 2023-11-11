//
//  MedicinesView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

//import SwiftData
import SwiftUI

struct MedicinesView: View {
    var medicines: Binding<[String]>
    @State private var showingAlert: Bool = false
    @State private var newMedicineName: String = ""
    
    var body: some View {
        Form {
            Section {
                ForEach(medicines.wrappedValue, id: \.self) { medicine in
                    Text(medicine)
                }
                .onDelete(perform: removeMedicines)
            }
            
            Section {
                Button("Add Medicine") {
                    showingAlert.toggle()
                }
            }
        }
        .alert("Add Medicine", isPresented: $showingAlert, actions: {
            TextField("Add Medicine", text: $newMedicineName)
            
            Button("Add", action: {
                if !newMedicineName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if !medicines.wrappedValue.contains(newMedicineName) {
                        medicines.wrappedValue.append(newMedicineName)
                        newMedicineName = ""
                    }
                }
            })
            Button("Cancel", role: .cancel, action: {})
        })
    }
    
    func removeMedicines(at offsets: IndexSet) {
        medicines.wrappedValue.remove(atOffsets: offsets)
    }
}

#Preview {
    MedicinesView(medicines: .constant([]))
}
