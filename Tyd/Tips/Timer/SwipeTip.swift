//
//  SwipeTip.swift
//  Tyd
//
//  Created by Ricky Kresslein on 16/1/24.
//

import Foundation
import TipKit

struct SwipeTip: Tip {
    var options: [TipOption] {
        [
            Tips.MaxDisplayCount(1)
        ]
    }
    
    var title: Text {
        Text("Swipe to delete")
    }
    
    var message: Text? {
        Text("Swipe an item left to delete it.")
    }
}
