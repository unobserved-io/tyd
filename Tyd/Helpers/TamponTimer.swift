//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/28/23.
//

import SwiftData
import SwiftUI

// TODO: Delete this file if TamponTimer model works

@Observable
class TamponTimer {
    var isRunning: Bool = false
    var formatted = "00:00:00"
    @ObservationIgnored var product: Product? = nil
    @ObservationIgnored var startTime: Date? = nil
    @ObservationIgnored var stopTime: Date? = nil
//    @ObservationIgnored var timedEvent: TimedEvent? = nil
    
    var timer: Timer = Timer()
    
    
    func start(product: Product, interval: Float) {
        /// Start running the timer
        isRunning = true
        self.product = product
        self.startTime = .now
        let intervalInSeconds: Int = Int(interval * 60 * 60)
        var secondsElapsed: Int = 0
        var secondsRemaining: Int = 0
        
        var timesUp: Bool = false
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                secondsElapsed = Calendar.current.dateComponents([.second], from: self.startTime ?? .now, to: Date.now).second ?? 0
                secondsRemaining = intervalInSeconds - secondsElapsed
                
                if secondsElapsed > intervalInSeconds {
                    timesUp = true
                }
                
                if !timesUp {
                    self.formatTime(secondsRemaining)
                } else {
                    self.formatTime(secondsElapsed)
                }
            }
        }
    }
    
    func stop() {
        /// Stop running the timer
        
    }
    
    func formatTime(_ secondsElapsed: Int) {
        /// Format time for stop watch clock
        let hours = secondsElapsed / 3600
        let hoursString = (hours < 10) ? "0\(hours)" : "\(hours)"
        let minutes = (secondsElapsed % 3600) / 60
        let minutesString = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        let seconds = secondsElapsed % 60
        let secondsString = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        formatted = hoursString + ":" + minutesString + ":" + secondsString
    }
}
