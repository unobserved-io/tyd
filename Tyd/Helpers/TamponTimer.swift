//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/28/23.
//

import SwiftData
import SwiftUI

@Observable
class TamponTimer {
    var isRunning: Bool = false
    var formatted = "00:00:00"
    var timesUp: Bool = false
    var progress: Double = 0.0
    @ObservationIgnored var intervalInSeconds: Int = 0
    @ObservationIgnored var product: Product? = nil
    @ObservationIgnored var startTime: Date? = nil
    @ObservationIgnored var stopTime: Date? = nil
    
    var timer: Timer = Timer()
    
    private func formatTime(_ secondsElapsed: Int) {
        /// Format time for stop watch clock
        let hours = secondsElapsed / 3600
        let hoursString = (hours < 10) ? "0\(hours)" : "\(hours)"
        let minutes = (secondsElapsed % 3600) / 60
        let minutesString = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        let seconds = secondsElapsed % 60
        let secondsString = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        formatted = hoursString + ":" + minutesString + ":" + secondsString
    }
    
    private func showLocalNotification(in scheduledFor: Int) {
        /// Register notification handler
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleLocalTimerNotification(in: Double(scheduledFor))
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func scheduleLocalTimerNotification(in scheduledFor: Double) {
        /// Set up notifications for Pomodoro timer
        let content = UNMutableNotificationContent()
        content.title = "It's time!"
        content.body = "It is time to change your \((product ?? .tampon).rawValue)."
        content.categoryIdentifier = "timer"
        content.sound = UNNotificationSound.default
        content.relevanceScore = 1.0
        content.interruptionLevel = UNNotificationInterruptionLevel.active
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: scheduledFor, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func start(product: Product, interval: Float) {
        /// Start running the timer
        isRunning = true
        self.product = product
        startTime = .now
        intervalInSeconds = Int(interval * 60 * 60)
        var secondsElapsed: Int = 0
        var secondsRemaining: Int = 0
        
        // Register notification
        showLocalNotification(in: intervalInSeconds)
        
        // To quickly display the amount of starting time before the timer starts
        formatTime(intervalInSeconds)
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                secondsElapsed = Calendar.current.dateComponents([.second], from: self.startTime ?? .now, to: Date.now).second ?? 0
                secondsRemaining = self.intervalInSeconds - secondsElapsed
                
                if secondsElapsed > self.intervalInSeconds {
                    self.timesUp = true
                    self.progress = 1.0
                } else {
                    self.timesUp = false
                    self.progress = Double(secondsElapsed) / Double(self.intervalInSeconds)
                }
                
                if !self.timesUp {
                    self.formatTime(secondsRemaining)
                } else {
                    self.formatTime(secondsElapsed)
                }
            }
        }
    }
    
    func stop() {
        /// Stop running the timer
        timer.invalidate()
        isRunning = false
        formatted = "00:00:00"
        timesUp = false
        stopTime = .now
    }
    
    func resetTimedEventData() {
        product = nil
        startTime = nil
        stopTime = nil
    }
    
    func updateNotificationTime() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let secondsElapsed = Calendar.current.dateComponents([.second], from: self.startTime ?? .now, to: Date.now).second ?? 0
        if secondsElapsed < intervalInSeconds {
            showLocalNotification(in: intervalInSeconds)
        }
    }
}
