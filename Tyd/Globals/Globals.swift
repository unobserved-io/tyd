//
//  Globals.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import Foundation

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    return dateFormatter
}()

let timeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "H:mm"
    return dateFormatter
}()

let calendar: Calendar = {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    return calendar
}()
