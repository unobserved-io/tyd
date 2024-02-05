//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Ricky Kresslein on 12/23/23.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TogglePeriodWidget()
        TimerWidgetLiveActivity()
    }
}
