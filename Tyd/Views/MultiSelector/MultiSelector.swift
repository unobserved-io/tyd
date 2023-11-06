//
//  MultiSelector.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/6/23.
//

import SwiftData
import SwiftUI

struct MultiSelector: View {
    let label: String
    let options: [String]

    var selected: Binding<Set<String>>

    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.sorted { $0 < $1 }.map {
            String(localized: String.LocalizationValue($0))
        })
    }

    var body: some View {
        NavigationLink(destination: multiSelectionView().navigationTitle("Add \(label)")) {
            HStack {
                Text(label)
                Spacer()
                if formattedSelectedListString.isEmpty {
                    Text("None")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                } else {
                    Text(formattedSelectedListString)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    private func multiSelectionView() -> some View {
        MultiSelectionView(
            options: options.sorted { String(localized: String.LocalizationValue($0)) < String(localized: String.LocalizationValue($1)) },
            selected: selected
        )
    }
}
