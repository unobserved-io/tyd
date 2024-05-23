//
//  TimerHelper.swift
//  Tyd
//
//  Created by Ricky Kresslein on 12/28/23.
//

import ActivityKit
import SwiftUI

@Observable
class TimerHelper {
    static let shared = TimerHelper()
    
    var isRunning: Bool = false
    var endTime: Date?
    var startTime: Date?
    var ended: Bool = false
    @ObservationIgnored var intervalInSeconds: Int = 0
    @ObservationIgnored var product: PeriodProduct? = nil
    @ObservationIgnored var stopTime: Date? = nil
    @ObservationIgnored var timer = Timer()
    
    @ObservationIgnored @AppStorage("ptIsRunning") private var ptIsRunning: Bool = false
    @ObservationIgnored @AppStorage("ptProduct") private var ptProduct: PeriodProduct = .tampon
    @ObservationIgnored @AppStorage("ptStartTime") private var ptStartTimeInt: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    
    @ObservationIgnored @AppStorage("showLiveActivity") var showLiveActivity: Bool = false

    func start(product: PeriodProduct, interval: Float) {
        /// Start running the timer
        isRunning = true
        self.product = product
        startTime = .now
        intervalInSeconds = Int(interval * 60 * 60)
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        
        setEndTimer()
        
        // Register notification
        showLocalNotification(in: intervalInSeconds)
        
        #if os(iOS)
        if showLiveActivity {
            startLiveActivity()
        }
        #endif
    }
    
    func stop() {
        /// Stop running the timer
        isRunning = false
        stopTime = .now
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        timer.invalidate()
        #if os(iOS)
        Task {
            await stopLiveActivity()
        }
        #endif
    }
    
    func resume(interval: Float) {
        isRunning = true
        intervalInSeconds = Int(interval * 60 * 60)
        timer.invalidate()
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        
        // Remove all pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Register a notification if the time has not already elapsed
        if Date.now < endTime ?? .distantPast {
            // Check if there is already a notification sent
            // If so, leave it be, if not set one
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { notifications in
                if notifications.count <= 0 {
                    self.showLocalNotification(in: Int(self.endTime?.timeIntervalSince(.now) ?? 0.0))
                }
            })
            setEndTimer()
        } else {
            setTimerEnded()
        }
        
        #if os(iOS)
        // On resume, don't start a live activity if one is already running
        if Activity<TimerWidgetAttributes>.activities.isEmpty, showLiveActivity {
            startLiveActivity()
        }
        #endif
    }
    
    func checkForResume(interval: Float) {
        /// Continue running timer if it was running when the app was closed and it is less than 48 hours old
        let ptStartTime = Date(timeIntervalSinceReferenceDate: ptStartTimeInt)
        if !isRunning &&
            ptIsRunning &&
            (Calendar.current.dateComponents(
                [.hour],
                from: ptStartTime,
                to: .now
            ).hour ?? 50 < 48
            )
        {
            product = ptProduct
            startTime = ptStartTime
            resume(interval: interval)
        }
    }
    
    func updateEndTime() {
        endTime = Calendar.current.date(byAdding: .second, value: intervalInSeconds, to: startTime ?? .now)
        timer.invalidate()
        setEndTimer()
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
    
    func startLiveActivity() {
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
    
    func stopLiveActivity() async {
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
    
    private func setEndTimer() {
        timer = Timer(fireAt: endTime ?? .distantPast, interval: 0, target: self, selector: #selector(setTimerEnded), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
}
