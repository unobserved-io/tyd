//
//  JustChangedTimerTip.swift
//  Tyd
//
//  Created by Ricky Kresslein on 16/1/24.
//

import Foundation
import TipKit

struct JustChangedTip: Tip {
    var title: Text {
        Text("Restart timer")
    }

    var message: Text? {
        Text("Tap this if you just changed your period product. Restarts the timer and saves the previous data.")
    }
    
    var actions: [Action] {
        [
            Action(id: "next-tip", title: "Next tip")
        ]
    }
}
