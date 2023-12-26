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
    }
}

struct TimerWidgetLiveActivity: Widget {
    let tydPurple: Color = .init(red: 0.5450980392, green: 0.5450980392, blue: 0.6901960784)
    @AppStorage("tydAccentColor") var tydAccentColor: String = "8B8BB0FF"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack {
                Spacer()
                
                Button {} label: {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.white)
                }
                .buttonBorderShape(.circle)
                .tint(.white)
                .font(.system(size: 25.0))
                
                Button {} label: {
                    Image(systemName: "repeat")
                        .foregroundColor(.white)
                }
                .buttonBorderShape(.circle)
                .tint(.white)
                .font(.system(size: 25.0))
                                    
                Text(
                    Date(
                        timeIntervalSinceNow: Double(context.state.startTime.timeIntervalSince1970) - Date().timeIntervalSince1970
                    ),
                    style: .timer
                )
                .font(Font.monospacedDigit(.system(size: 60.0))())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10.0)
            .background(LinearGradient(gradient: Gradient(colors: [tydPurple.opacity(0.35), tydPurple]), startPoint: .top, endPoint: .bottom))
            .activityBackgroundTint(Color.white)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Button {} label: {
                            Image(systemName: "stop.fill")
                                .foregroundColor(.accent)
                        }
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                        
                        Button {} label: {
                            Image(systemName: "repeat")
                                .foregroundColor(.accent)
                        }
                        .buttonBorderShape(.circle)
                        .tint(.accent)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image("Tyd15-Accent")
                        .padding(.top, 8.0)
                        .padding(.trailing, 7.0)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(
                        Date(
                            timeIntervalSinceNow: Double(context.state.startTime.timeIntervalSince1970) - Date().timeIntervalSince1970
                        ),
                        style: .timer
                    )
                    .font(Font.monospacedDigit(.system(size: 60.0))())
                    .foregroundStyle(.accent)
                }
            } compactLeading: {
                Image("Tyd15-Accent")
            } compactTrailing: {
                Text(
                    Date(
                        timeIntervalSinceNow: Double(context.state.startTime.timeIntervalSince1970) - Date().timeIntervalSince1970
                    ),
                    style: .timer
                )
                .foregroundStyle(.accent)
            } minimal: {
                Image("Tyd15-Accent")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
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
    TimerWidgetAttributes.ContentState(startTime: .now)
}
