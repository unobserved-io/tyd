//
//  TamponTimer.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/28/23.
//

import SwiftUI

@Observable
class TamponTimerHelper {
    static let sharedInstance = TamponTimerHelper()
    
    var isRunning = false
}
