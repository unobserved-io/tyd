//
//  ContentView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/27/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var days: [Day]
    var tamponTimer = TamponTimerHelper.sharedInstance
    @State var timerProgress: Float = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                // TODO: Only show if the timer is running
                if tamponTimer.isRunning {
                    ProgressBar(progress: $timerProgress)
                        .offset(y: 40)
                }
                
                // TODO: Use the new hints feature to tell user on first load to tap the image to start period?
                Button {
                    
                } label: {
                    Image("TydLogo")
                        .imageScale(.small)
                        .opacity(0.3)
                }
            }
            .padding(.top)

            Button("Progress") {
                timerProgress += 0.1
                tamponTimer.isRunning = true
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Day.self, inMemory: true)
}
