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
    let dayTaken: String
    @State var medName: String = ""
    @State var medTime: Date = .now
    @State var medDose: String = ""

    init(dayTaken: String = "") {
        self.dayTaken = dayTaken
//        dayTakenString = dateFormatter.string(from: dayTaken)
//        _dayData = FetchRequest(
//            sortDescriptors: [],
//            predicate: NSPredicate(format: "date = %@", dayTakenString)
//        )
    }

    var body: some View {
        Form {
            // Name field
            Picker("Medication", selection: $medName) {
                ForEach(appData.first?.medication ?? [], id: \.self) { name in
                    Text(LocalizedStringKey(name.localizedCapitalized))
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
            TextField("Dose", text: $medDose)
        }
    }
}

// #Preview {
//    AddEditMedicationView()
// }
