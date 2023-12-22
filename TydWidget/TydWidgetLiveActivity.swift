//
//  TydWidgetLiveActivity.swift
//  TydWidget
//
//  Created by Ricky Kresslein on 12/22/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TydWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TydWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TydWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TydWidgetAttributes {
    fileprivate static var preview: TydWidgetAttributes {
        TydWidgetAttributes(name: "World")
    }
}

extension TydWidgetAttributes.ContentState {
    fileprivate static var smiley: TydWidgetAttributes.ContentState {
        TydWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TydWidgetAttributes.ContentState {
         TydWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TydWidgetAttributes.preview) {
   TydWidgetLiveActivity()
} contentStates: {
    TydWidgetAttributes.ContentState.smiley
    TydWidgetAttributes.ContentState.starEyes
}
