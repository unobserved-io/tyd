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
            Text("DAY 29")
                .bold()
                .padding(.bottom)
            
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
            
            //TODO: If not on period or PMS, show the helper text
            // Tampon timer will also only be available when on period, so this
            // won't show when tampon timer is on.
            if !tamponTimer.isRunning {
                VStack {
                    Text("Tap for period")
                        .foregroundStyle(.accent)
                    Text("Hold for PMS")
                        .foregroundStyle(.accent)
                }
                .padding(.top)
            }

//            Button("Progress") {
//                timerProgress += 0.1
//                tamponTimer.isRunning = true
//            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Day.self, inMemory: true)
}
