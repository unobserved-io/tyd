//
//  AccentColorPickerView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

import SwiftUI

struct AccentColorPickerView: View {
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    @State private var showingAlert: Bool = false

    var body: some View {
        Form {
            Section {
                ColorPicker("App color", selection: Binding(get: {
                    Color(hex: tydAccentColor) ?? .accent
                },
              set: { newValue in
                    tydAccentColor = newValue.hex ?? "8B8BB0FF"
              }))
            }
            Section {
                Button("Reset to defaults") {
                    showingAlert.toggle()
                }
            }
        }
        .alert("Reset?", isPresented: $showingAlert) {
            Button("Reset") {
                tydAccentColor = "8B8BB0FF"
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to reset all colors to defaults?")
        }
    }
}

#Preview {
    AccentColorPickerView()
}
