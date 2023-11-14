//
//  AddEditMedicationView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/7/23.
//

import SwiftData
import SwiftUI

struct AddEditMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @Query private var appData: [AppData]
    @Binding var medication: Medication

    var body: some View {
        VStack(spacing: 10) {
            // Name field
            HStack {
                Text("Medication")
                Spacer()
                Picker("Medication", selection: $medication.name) {
                    ForEach(appData.first?.medicines ?? [], id: \.self) { name in
                        Text(LocalizedStringKey(name.localizedCapitalized))
                    }
                }
            }

            // Time taken field
            DatePicker(
                "Time Taken",
                selection: $medication.time,
                in: ...Date.now,
                displayedComponents: [.hourAndMinute]
            )

            // Dose field
            HStack {
                Text("Dose")
                Spacer()
                TextField("20 mg, etc.", text: $medication.dose)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .onAppear {
            if medication.name.isEmpty {
                medication.name = appData.first?.medicines.first ?? ""
            }
        }
    }
}

#Preview {
    AddEditMedicationView(medication: .constant(Medication()))
}
