//
//  Double+Format.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    static let meterToFootFactor = 0.3048
    static let meterToMileFactor = 1609.344
    static let meterToKilometerFactor = 1000.0
    static let meterToKilometerThreshold = 1000.0
    static let footToMileThreshold = 528.0

    var mileageFormattedNoSpace: String {
        if Locale.current.usesMetricSystem {
            return String(format: NSLocalizedString("km_formatted_no_space", comment: ""), mileage)
        }
        return String(format: NSLocalizedString("mi_formatted_no_space", comment: ""), mileage)
    }

    var mileageFormatted: String {
        if Locale.current.usesMetricSystem {
            return String(format: NSLocalizedString("km_formatted", comment: ""), mileage)
        }
        return String(format: NSLocalizedString("mi_formatted", comment: ""), mileage)
    }

    var minutes: Double {
        return ceil(self / 60.0)
    }

    var feetFormatted: String {
        return "\(feet) ft"
    }

    var mileage: String {
        let mileage: Double
        if Locale.current.usesMetricSystem {
            mileage = self / .meterToKilometerFactor
        } else {
            mileage = self / .meterToMileFactor
        }
        return mileage.formatKilo
    }

    var meter: Double {
        return self * 1609.344
    }

    var mile: Double {
        return self / 1609.344
    }

    var feet: String {
        let foot = self / .meterToFootFactor
        return String(format: "%.f", ceil(foot * 10) / 10)
    }

    // Takes meters as input
    var calculatedDistance: String {
        if Locale.current.usesMetricSystem {
            if self < .meterToKilometerThreshold {
                return String(format: "%@ m away", String(format: "%.1f", ceil(self * 10) / 10))
            } else {
                return String(format: "%@ km away", String(format: "%.1f", ceil((self / .meterToKilometerFactor) * 10) / 10))
            }
        } else {
            let foot = self / .meterToFootFactor
            if foot < .footToMileThreshold {
                return String(format: "%@ ft away", String(format: "%.1f", ceil(foot * 10) / 10))
            } else {
                return String(format: "%@ mi away", String(format: "%.1f", ceil((self / .meterToMileFactor) * 10) / 10))
            }
        }
    }

    var formatKilo: String {
        if self.truncatingRemainder(dividingBy: 1.0) == 0 && self < 10000 { // 10 -> 10
            return String(format: "%d", Int64(self))
        } else if self < 10000 { // 13.54 -> 13.6
            return String(format: "%.1f", ceil(self * 10) / 10)
        } else {
            if self.truncatingRemainder(dividingBy: 1000.0) == 0 { // 12000 -> 12k
                return String(format: "%d" + "k", Int64(self / 1000))
            } else { // 14352 -> 14.4k
                return String(format: "%.1f" + "k", ceil(self / 100) / 10)
            }
        }
    }
}

