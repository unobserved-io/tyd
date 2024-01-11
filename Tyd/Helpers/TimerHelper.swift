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
    var endTime: Date?
    var startTime: Date?
    var ended: Bool = false
    @ObservationIgnored var intervalInSeconds: Int = 0
    @ObservationIgnored var product: PeriodProduct? = nil
    @ObservationIgnored var stopTime: Date? = nil

    func start(product: PeriodProduct, interval: Float, liveActivity: Bool = false) {
        /// Start running the timer
        isRunning = true
        self.product = product
        startTime = .now
        intervalInSeconds = Int(interval * 60 * 60)
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        
        let timer = Timer(fireAt: endTime ?? .distantPast, interval: 0, target: self, selector: #selector(setTimerEnded), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
        
        // Register notification
        showLocalNotification(in: intervalInSeconds)
        
        #if os(iOS)
        if liveActivity {
            startLiveActivity()
        }
        #endif
    }
    
    func stop() {
        /// Stop running the timer
        isRunning = false
        stopTime = .now
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        #if os(iOS)
        Task {
            await stopLiveActivity()
        }
        #endif
    }
    
    func resume(interval: Float, liveActivity: Bool = false) {
        isRunning = true
        intervalInSeconds = Int(interval * 60 * 60)
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        
        // Remove all pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Register a notification if the time has not already elapsed
        if Date.now < endTime ?? .distantPast {
            showLocalNotification(in: Int(endTime?.timeIntervalSince(.now) ?? 0.0))
            
            let timer = Timer(fireAt: endTime ?? .distantPast, interval: 0, target: self, selector: #selector(setTimerEnded), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
        
        #if os(iOS)
        // On resume, don't start a live activity if one is already running
        if Activity<TimerWidgetAttributes>.activities.isEmpty, liveActivity {
            startLiveActivity()
        }
        #endif
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
        
        for activeActivities in Activity<TimerWidgetAttributes>.activities {
            await activeActivities.update(
                ActivityContent<TimerWidgetAttributes.ContentState>(
                    state: updatedState,
                    staleDate: Calendar.current.date(byAdding: .hour, value: 24, to: .now)
                )
            )
        }
    }
    
    func resetTimedEventData() {
        product = nil
        startTime = nil
        stopTime = nil
        ended = false
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
                
                _ = try Activity.request(
                    attributes: timerWidget,
                    content: .init(state: initialState, staleDate: Calendar.current.date(byAdding: .hour, value: 24, to: .now)),
                    pushType: .token
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func stopLiveActivity() async {
        let finalContent = TimerWidgetAttributes.ContentState(
            startTime: startTime ?? .now,
            endTime: endTime ?? .distantFuture,
            stoppedTime: stopTime
        )
            
        for activeActivities in Activity<TimerWidgetAttributes>.activities {
            await activeActivities.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: .immediate)
        }
    }
    
    @objc func setTimerEnded() {
        ended = true
    }
}
