//
//  Date+Interval.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-27.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

extension Date {
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    static func calcTimeDuration(startDate: Date, endDate: Date) -> String {
        let hourDuration = endDate.hours(from: startDate)
        var minuteDuration = endDate.minutes(from: startDate) - 60 * hourDuration
        let duration: String
        if minuteDuration < 0 {
            minuteDuration = 0
        }

        if hourDuration == 0 {
            duration = String(minuteDuration) + "mins"
        } else if minuteDuration == 0 {
            duration = String(hourDuration) + "h"
        } else {
            duration = String(hourDuration) + "h" + String(minuteDuration) + "mins"
        }
        return duration
    }
}

extension Date {
    static var amPmFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.amSymbol = "AM"
        formater.pmSymbol = "PM"
        return formater
    }()
}
