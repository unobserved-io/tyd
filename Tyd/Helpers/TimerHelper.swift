//
//  TimerHelper.swift
//  Tyd
//
//  Created by Ricky Kresslein on 12/28/23.
//

import ActivityKit
import SwiftUI
import TimerWidgetExtension

@Observable
class TimerHelper {
    var isRunning: Bool = false
    var progress: Double = 0.0
    var endTime: Date?
    var startTime: Date?
    @ObservationIgnored var intervalInSeconds: Int = 0
    @ObservationIgnored var product: Product? = nil
    @ObservationIgnored var stopTime: Date? = nil
    @ObservationIgnored var activity: Activity<TimerWidgetAttributes>? = nil
    
    func start(product: Product, interval: Float) {
        /// Start running the timer
        isRunning = true
        self.product = product
        startTime = .now
        intervalInSeconds = Int(interval * 60 * 60)
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        
        // Register notification
        showLocalNotification(in: intervalInSeconds)
        
        startLiveActivity()

        // TODO: Add progress for bar on main page
    }
    
    func stop() {
        /// Stop running the timer
        isRunning = false
        stopTime = .now
        Task {
            await stopLiveActivity()
        }
    }
    
    func resume(interval: Float) {
        isRunning = true
        intervalInSeconds = Int(interval * 60 * 60)
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        
        // Register a notification if the time has not already elapsed
        if Date.now > endTime ?? .distantPast {
            showLocalNotification(in: Int(endTime?.timeIntervalSince(startTime ?? .now) ?? 0.0))
            print(Int(endTime?.timeIntervalSince(startTime ?? .now) ?? 0.0))
        }
        
        // On resume, don't start a live activity if one is already running
        // TODO: This does not matter if the app had been closed
        if activity == nil {
            startLiveActivity()
        }
    }
    
    func updateEndTime() {
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
    }
    
    func updateNotificationTime() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let secondsElapsed = Calendar.current.dateComponents([.second], from: startTime ?? .now, to: Date.now).second ?? 0
        if secondsElapsed < intervalInSeconds {
            showLocalNotification(in: intervalInSeconds)
        }
    }
    
    func updateLiveActivity() async {
        let updatedState = TimerWidgetAttributes.ContentState(
            startTime: startTime ?? .now,
            endTime: endTime ?? .distantFuture
        )
        
        await activity?.update(
            ActivityContent<TimerWidgetAttributes.ContentState>(
                state: updatedState,
                staleDate: Calendar.current.date(byAdding: .hour, value: 24, to: .now)
            )
        )
    }
    
    func resetTimedEventData() {
        product = nil
        startTime = nil
        stopTime = nil
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
    
    private func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let timerWidget = TimerWidgetAttributes()
                let initialState = TimerWidgetAttributes.ContentState(
                    startTime: startTime ?? .now,
                    endTime: endTime ?? .distantFuture
                )
                
                activity = try Activity.request(
                    attributes: timerWidget,
                    content: .init(state: initialState, staleDate: Calendar.current.date(byAdding: .hour, value: 24, to: .now)),
                    pushType: .token
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // TODO: Dismiss live activity when the app is terminated
    private func stopLiveActivity() async {
        if activity == nil {
            return
        }
                        
        let finalContent = TimerWidgetAttributes.ContentState(
            startTime: startTime ?? .now,
            endTime: endTime ?? .distantFuture,
            stoppedTime: stopTime
        )
            
        await activity?.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: .immediate)
    }
    
}
