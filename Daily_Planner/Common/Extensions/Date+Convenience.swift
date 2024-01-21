//
//  Date+Convenience.swift
//  Daily_Planner
//
//  Created by Daniil on 20.01.2024.
//

import Foundation

extension Date {

    var range: ClosedRange<TimeInterval>? {
        guard let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) else {
            return nil
        }
        let start = Calendar.current.startOfDay(for: self)
        let range = start.timeIntervalSince1970...end.timeIntervalSince1970
        return range
    }

    var byHoursX: [Hour]? {
        let hours = (0...23).compactMap { (num) -> Hour? in
            guard let start = Calendar.current.date(bySettingHour: num, minute: 0, second: 0, of: self),
                  let end = Calendar.current.date(bySettingHour: num, minute: 59, second: 59, of: self) else {
                return nil
            }
            let formattedStart = String(format: "%02d", num)
            let formattedEnd = String(format: "%02d", num + 1)
            let title = formattedStart + ":00 - " + formattedEnd + ":00"
            let range = start.timeIntervalSince1970+1...end.timeIntervalSince1970
            let hour = Hour(title: title, range: range)
            return hour
        }
        return hours.count == 24 ? hours : nil
    }

}
