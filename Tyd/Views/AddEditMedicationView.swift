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
    @Query var medication: [Medication]
    
    init(predicate: Predicate<Medication>) {
        _medication = Query(filter: predicate)
    }

    var body: some View {
        VStack {
            // Name field
            HStack {
                Text("Medication")
                Spacer()
                Picker("Medication", selection: Bindable(medication.first ?? Medication()).name) {
                    ForEach(appData.first?.medication ?? [], id: \.self) { name in
                        Text(LocalizedStringKey(name.localizedCapitalized))
                    }
                }
            }

            // Time taken field
            DatePicker(
                "Time Taken",
                selection: Bindable(medication.first ?? Medication()).time,
                in: ...Date.now,
                displayedComponents: [.hourAndMinute]
            )

            // Dose field
            HStack {
                Text("Dose")
                Spacer()
                TextField("20 mg, etc.", text: Bindable(medication.first ?? Medication()).dose)
                    .multilineTextAlignment(.trailing)
            }
            
            // Save & Cancel
            HStack(spacing: 15) {
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 10)
        }
        .padding()
        .onAppear {
            if medication.first?.name.isEmpty ?? false {
                medication.first?.name = appData.first?.medication.first ?? ""
            }
            // TODO: Set original vars to set everything back to if user clicks cancel
            // TODO: If keeping Save & Cancel, use and 'existing' init var to see if the medication already existed
            // TODO: That way we know whether to discard changes or delete it on Cancel
            // TODO: Or replace Save & Cancel with just a Close button. User can reset changes or delete med on their own
        }
    }
}

// #Preview {
//    AddEditMedicationView()
// }
