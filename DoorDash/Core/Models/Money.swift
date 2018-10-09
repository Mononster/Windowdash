//
//  Money.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

public enum Currency: String {
    case USD // United States
    case CHF // Switzerland
    case EUR // Germany
    case AUD // Australia
    case NZD // New Zealand
    case CZK // Czech Republic
    case DKK // Denmark
    case ILS // Israel
    case NOK // Norway
    case SEK // Sweden
    case PLN // Poland
    case GBP // Great Britain
    case CAD // Canada
    case JPY // Japan

    public var code: String {
        return self.rawValue
    }

    // Note: This is being used for error cases
    public var symbol: String {
        switch self {
        case .USD, .AUD, .NZD, .CAD:
            return "$"
        case .CHF:
            return "F"
        case .EUR:
            return "€"
        case .CZK:
            return "Kč"
        case .DKK:
            return "Kr."
        case .ILS:
            return "₪"
        case .NOK, .SEK:
            return "kr"
        case .PLN:
            return "zł"
        case .GBP:
            return "£"
        case .JPY:
            return "¥"
        }
    }

    // Most currencies in the world feature a centesimal (​1⁄100) unit (https://en.wikipedia.org/wiki/Cent_(currency))
    // However around 9 do not.  One of those currencies is the Czech Krona: https://en.wikipedia.org/wiki/Czech_koruna
    public var centsDivisor: UInt16 {
        switch self {
        case .USD, .EUR, .AUD, .NZD, .DKK, .ILS,
             .NOK, .SEK, .PLN, .GBP, .CAD, .CHF:
            return 100
        case .CZK, .JPY:
            return 1
        }
    }

    public var centsDigits: UInt8 {
        switch self {
        case .USD, .EUR, .AUD, .NZD, .DKK, .ILS,
             .NOK, .SEK, .PLN, .GBP, .CAD, .CHF:
            return 2
        case .CZK, .JPY:
            return 0
        }
    }
}

public class Money: Comparable {
    public let currency: Currency
    public var cents: Int64
    public var moneyLocale: Locale = Locale.current

    public init(cents: Int64, currency: Currency) {
        self.cents = cents
        self.currency = currency
    }

    public init?(cents: String, currency: Currency) {
        guard let centsValue = Int64(cents) else {
            return nil
        }
        self.cents = centsValue
        self.currency = currency
    }

    static public var zero: Money {
        return Money(cents: 0, currency: .USD)
    }

    public var centsAmount: Decimal {
        return Decimal(cents)
    }

    public var dollarAmount: Decimal {
        return centsAmount / Decimal(currency.centsDivisor)
    }

    public func add(cents: Int64) {
        self.cents += cents
    }

    public func getLocaleWithCurrencyCode(from currencyCode: String) -> Locale {
        var locale = Locale.current

        if locale.currencyCode != currencyCode {
            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
            locale = NSLocale(localeIdentifier: identifier) as Locale
        }
        return locale
    }

    public func toString(withCurrencyCode code: String) -> String {
        let formatter = configureFormatter(with: getLocaleWithCurrencyCode(from: code))
        return formatter.string(from: dollarAmount as NSNumber) ?? "\(currency.symbol)0.00"
    }

    public func toString() -> String {
        let formatter = configureFormatter(with: getLocaleWithCurrencyCode(from: currency.code))
        return formatter.string(from: dollarAmount as NSNumber) ?? "\(currency.symbol)0.00"
    }

    public func toFloatString() -> String {
        let formatter = configureFormatter(with: getLocaleWithCurrencyCode(from: currency.code), maximumFractionDigits: 2, minimumFractionDigits: 2)
        return formatter.string(from: dollarAmount as NSNumber) ?? "\(currency.symbol)0.00"
    }

    public func toIntegerString() -> String {
        let formatter = configureFormatter(with: getLocaleWithCurrencyCode(from: currency.code), maximumFractionDigits: 0)
        return formatter.string(from: dollarAmount as NSNumber) ?? "\(currency.symbol)0"
    }

    public func toShortIntegerString() -> String {
        // (Used for displays on pins only)
        // Set the formatter locale to current locale so it will not display extra letters, e.g US$ -> $
        let formatter = configureFormatter(with: self.moneyLocale, maximumFractionDigits: 0)
        return formatter.string(from: dollarAmount as NSNumber) ?? "\(currency.symbol)0"
    }

    public func negative() -> Money {
        return Money(cents: self.cents * -1, currency: self.currency)
    }

    private func configureFormatter(with locale: Locale, maximumFractionDigits: Double? = -1, minimumFractionDigits: Double? = -1) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        if minimumFractionDigits! > 0 {
            numberFormatter.minimumFractionDigits = Int(minimumFractionDigits!)
        } else {
            let maxFractionDigits = maximumFractionDigits! >= 0 ? Int(maximumFractionDigits!) : Int(currency.centsDigits)
            numberFormatter.maximumFractionDigits = maxFractionDigits
            numberFormatter.minimumFractionDigits = 0
        }
        return numberFormatter
    }

    public var isNegative: Bool {
        return cents < 0
    }

    public var isBelowMinBalanceToTakeRide: Bool {
        return cents < 50
    }
}

public func < (lhs: Money, rhs: Money) -> Bool {
    return lhs.cents < rhs.cents
}

public func <= (lhs: Money, rhs: Money) -> Bool {
    return lhs.cents <= rhs.cents
}

public func >= (lhs: Money, rhs: Money) -> Bool {
    return lhs.cents >= rhs.cents
}

public func > (lhs: Money, rhs: Money) -> Bool {
    return lhs.cents > rhs.cents
}

public func == (lhs: Money, rhs: Money) -> Bool {
    return lhs.currency == rhs.currency && lhs.cents == rhs.cents
}

