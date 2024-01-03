//
//  EditTimedEventView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/13/23.
//

import SwiftData
import SwiftUI

struct EditTimedEventView: View {
    @Binding var timedEvent: TimedEvent
    @Query private var appData: [AppData]
    
    var body: some View {
        VStack {
            // Product field
            HStack {
                Text("Product")
                Spacer()
                Picker("Product", selection: $timedEvent.product){
                    ForEach(PeriodProduct.allCases, id: \.rawValue) { product in
                        Text(LocalizedStringKey(product.rawValue.localizedCapitalized)).tag(product)
                    }
                }
            }
            
            // Start time field
            DatePicker(
                "Start time",
                selection: $timedEvent.startTime,
                in: ...timedEvent.stopTime,
                displayedComponents: [.hourAndMinute]
            )
            
            // Stop time field
            DatePicker(
                "End time",
                selection: $timedEvent.stopTime,
                in: timedEvent.startTime ... .now,
                displayedComponents: [.hourAndMinute]
            )
        }
        .padding()
    }
}

//#Preview {
//    EditTimedEventView()
//}
