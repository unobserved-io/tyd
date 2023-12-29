//
//  Globals.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import Foundation

let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}()

let calendar: Calendar = {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    return calendar
}()

let defaultPeriodSymptoms: [String] = [
    "Anxious",
    "Back pain",
    "Bloating",
    "Breast tenderness",
    "Constipation",
    "Cramps",
    "Diarrhea",
    "Fatigue",
    "Headache",
    "Insomnia",
    "Irritable",
    "Joint pain",
    "Muscle aches",
    "Nausea",
    "Painful defecation",
    "Pimples"
]

let defaultPmsSymptoms: [String] = [
    "Anger",
    "Anxious",
    "Back pain",
    "Bloating",
    "Breast tenderness",
    "Changed appetite",
    "Changed sex drive",
    "Constipation",
    "Cramps",
    "Diarrhea",
    "Dizziness",
    "Fatigue",
    "Headache",
    "Insomnia",
    "Irritable",
    "Joint pain",
    "Muscle aches",
    "Nausea",
    "Painful defecation",
    "Pimples",
    "Sadness"
]
