//
//  TydWidgetBundle.swift
//  TydWidget
//
//  Created by Ricky Kresslein on 12/22/23.
//

import WidgetKit
import SwiftUI

@main
struct TydWidgetBundle: WidgetBundle {
    var body: some Widget {
        TydWidget()
        TydWidgetLiveActivity()
    }
}
