//
//  Functions.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import Foundation

func getTodaysDate() -> String {
    return dateFormatter.string(from: Date.now)
}
