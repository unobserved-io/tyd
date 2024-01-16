//
//  StartTimeTimerTip.swift
//  Tyd
//
//  Created by Ricky Kresslein on 16/1/24.
//

import Foundation
import TipKit

struct StartTimeTip: Tip {
    var title: Text {
        Text("Change start time")
    }
    
    var message: Text? {
        Text("Tap this to change the time you began using the current product.")
    }
}
