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
    @EnvironmentObject var medication: ClickedMedication
    @Query private var appData: [AppData]
    @State var medName: String = ""
    @State var medTime: Date = .now
    @State var medDose: String = ""

    var body: some View {
        VStack {
            // Name field
            HStack {
                Text("Medication")
                Spacer()
                Picker("Medication", selection: $medName) {
                    ForEach(appData.first?.medication ?? [], id: \.self) { name in
                        Text(LocalizedStringKey(name.localizedCapitalized))
                    }
                }
            }

            // Time taken field
            DatePicker(
                "Time Taken",
                selection: $medTime,
                in: ...Date.now,
                displayedComponents: [.hourAndMinute]
            )

            // Dose field
            HStack {
                Text("Dose")
//                    .frame(alignment: .leading)
                Spacer()
                TextField("20 mg, etc.", text: $medDose)
                    .multilineTextAlignment(.trailing)
            }
            
            // Save & Cancel
            HStack(spacing: 15) {
                Button("Save") {
                    // TODO: Save behavior
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                Button("Cancel") {
                    // TODO: Cancel behavior
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 10)
        }
        .padding()
        .onAppear {
            medName = medication.medication?.name ?? ""
            if medName.isEmpty {
                medName = appData.first?.medication.first ?? ""
            }
            medTime = medication.medication?.time ?? .now
            medDose = medication.medication?.dose ?? ""
        }
    }
}

// #Preview {
//    AddEditMedicationView()
// }
