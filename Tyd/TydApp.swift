//
//  TydApp.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftData
import SwiftUI

@main
struct TydApp: App {
//    let modelContainer: ModelContainer
        
//        init() {
//            do {
//                modelContainer = try ModelContainer(for:
//                    AppData.self,
//                    Day.self,
//                    Medication.self,
//                    TamponTimer.self
//                )
//            } catch {
//                fatalError("Could not initialize ModelContainer")
//            }
//        }
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
        }
        .modelContainer(for: [
            AppData.self,
            Day.self,
            Medication.self,
            TamponTimer.self
        ])
    }
}
