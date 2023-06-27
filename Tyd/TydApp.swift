//
//  TydApp.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftUI
import SwiftData

@main
struct TydApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
