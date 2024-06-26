//
//  MultiSelectionView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/6/23.
//

import SwiftUI

struct MultiSelectionView: View {
    let options: [String]

    @Binding var selected: Set<String>

    var body: some View {
        List {
            ForEach(options, id: \.self) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text(LocalizedStringKey(selectable)).foregroundColor(.primary)
                        Spacer()
                        if selected.contains(selectable) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        #if os(iOS)
        .listStyle(GroupedListStyle())
        #endif
    }

    private func toggleSelection(selectable: String) {
        if selected.contains(selectable) {
            selected.remove(selectable)
        } else {
            selected.insert(selectable)
        }
    }
}
