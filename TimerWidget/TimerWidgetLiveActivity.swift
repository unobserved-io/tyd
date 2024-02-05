//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Ricky Kresslein on 12/23/23.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startTime: Date
        var endTime: Date
        var stoppedTime: Date? = nil
    }
}

struct TimerWidgetLiveActivity: Widget {
    let tydPurple: Color = .init(red: 0.5450980392, green: 0.5450980392, blue: 0.6901960784)

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            HStack {
//                Spacer()

                if context.state.stoppedTime == nil {
                    Text(
                        context.state.endTime,
                        style: .timer
                    )
                    .font(Font.monospacedDigit(.system(size: 50.0))())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                } else {
                    Text(formatTime(Calendar.current.dateComponents([.second], from: context.state.startTime, to: context.state.stoppedTime ?? .now).second ?? 0))
                        .font(Font.monospacedDigit(.system(size: 50.0))())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                if context.state.stoppedTime == nil {
                    Button(intent: StopTimerIntent()){
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                    }
                    .buttonBorderShape(.circle)
                    .tint(.white)
                    .font(.system(size: 20.0))

//                    Button {} label: {
//                        Image(systemName: "repeat")
//                            .foregroundColor(.white)
//                    }
//                    .buttonBorderShape(.circle)
//                    .tint(.white)
//                    .font(.system(size: 20.0))
                } else {
                    Image("Tyd25")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10.0)
            .background(LinearGradient(gradient: Gradient(colors: [tydPurple.opacity(0.35), tydPurple]), startPoint: .top, endPoint: .bottom))
            .activityBackgroundTint(Color.white)
            .activitySystemActionForegroundColor(Color.black)
            .widgetURL(URL(string: "tyd://timerView"))

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
//                    HStack {
//                        Button {} label: {
//                            Image(systemName: "stop.fill")
//                                .foregroundColor(.accent)
//                        }
//                        .buttonBorderShape(.circle)
//                        .tint(.accent)
//
//                        Button {} label: {
//                            Image(systemName: "repeat")
//                                .foregroundColor(.accent)
//                        }
//                        .buttonBorderShape(.circle)
//                        .tint(.accent)
//                    }
                    Button {} label: {
                        Text("Tyd timer")
                            .foregroundColor(.accent)
                    }
                    .buttonBorderShape(.circle)
                    .tint(.accent.opacity(0.0))
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Button {} label: {
                        Image("Tyd15-Accent")
                    }
                    .buttonBorderShape(.circle)
                    .tint(.accent.opacity(0.0))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.stoppedTime == nil {
                        Text(
                            context.state.endTime,
                            style: .timer
                        )
                        .font(Font.monospacedDigit(.system(size: 60.0))())
                        .foregroundStyle(.accent)
                        .multilineTextAlignment(.center)
                    } else {
                        Text(formatTime(Calendar.current.dateComponents([.second], from: context.state.startTime, to: context.state.stoppedTime ?? .now).second ?? 0))
                            .font(Font.monospacedDigit(.system(size: 60.0))())
                            .foregroundStyle(.accent)
                            .multilineTextAlignment(.center)
                    }
                }
            } compactLeading: {
                Image("Tyd15-Accent")
                    .padding(.leading, 3)
            } compactTrailing: {
                Text(
                    context.state.endTime,
                    style: .timer
                )
                .frame(maxWidth: .minimum(65, 65), alignment: .leading)
                .padding(-2)
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
            } minimal: {
                Image("Tyd15-Accent")
            }
            .widgetURL(URL(string: "tyd://timerView"))
            .keylineTint(.accent)
        }
    }

    private func formatTime(_ secondsElapsed: Int) -> String {
        /// Format time for stop watch clock
        let hours = secondsElapsed / 3600
        let hoursString = (hours < 10) ? "0\(hours)" : "\(hours)"
        let minutes = (secondsElapsed % 3600) / 60
        let minutesString = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        let seconds = secondsElapsed % 60
        let secondsString = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        return hoursString + ":" + minutesString + ":" + secondsString
    }
}

private extension TimerWidgetAttributes {
    static var preview: TimerWidgetAttributes {
        TimerWidgetAttributes()
    }
}

#Preview("Notification", as: .content, using: TimerWidgetAttributes.preview) {
    TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState(startTime: .now, endTime: Calendar.current.date(byAdding: .hour, value: 23, to: .now) ?? .now)
    // stoppedTime: Calendar.current.date(byAdding: .hour, value: 5, to: .now) ?? .now
}
