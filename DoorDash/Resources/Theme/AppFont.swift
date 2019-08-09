//
//  AppFont.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum FontStyle {
    case regular
    case extraBold
    case bold
    case semiBold
    case medium
    case light
    case heavy
}

protocol FontSchema {
    /* Basic fonts */
    var regular10: UIFont { get }
    var regular12: UIFont { get }
    var regular14: UIFont { get }
    var regular15: UIFont { get }
    var regular16: UIFont { get }
    var regular18: UIFont { get }
    var regular24: UIFont { get }
    var medium10: UIFont { get }
    var medium12: UIFont { get }
    var medium13: UIFont { get }
    var medium14: UIFont { get }
    var medium15: UIFont { get }
    var medium16: UIFont { get }
    var medium18: UIFont { get }
    var medium20: UIFont { get }
    var medium24: UIFont { get }
    var semiBold12: UIFont { get }
    var semiBold14: UIFont { get }
    var semiBold16: UIFont { get }
    var semiBold17: UIFont { get }
    var semiBold20: UIFont { get }
    var semiBold42: UIFont { get }
    var bold10: UIFont { get }
    var bold12: UIFont { get }
    var bold14: UIFont { get }
    var bold15: UIFont { get }
    var bold16: UIFont { get }
    var bold17: UIFont { get }
    var bold18: UIFont { get }
    var bold20: UIFont { get }
    var bold24: UIFont { get }
    var bold28: UIFont { get }
    var bold30: UIFont { get }
    var bold32: UIFont { get }
    var bold40: UIFont { get }
    var heavy12: UIFont { get }
    var heavy16: UIFont { get }
    var heavy18: UIFont { get }
    var extraBold10: UIFont { get }
    var extraBold12: UIFont { get }
    var extraBold14: UIFont { get }
    var extraBold16: UIFont { get }
    var extraBold17: UIFont { get }
    var extraBold18: UIFont { get }

    /* Font templates */
    var titleRegular: UIFont { get }
    var agreementLabelFont: UIFont { get }
}

struct DefaultFontSchema: FontSchema {
    /* Basic fonts */
    var regular10: UIFont {
        return font(size: 10)
    }

    var regular12: UIFont {
        return font(size: 12)
    }

    var regular14: UIFont {
        return font(size: 14)
    }

    var regular15: UIFont {
        return font(size: 15)
    }

    var regular16: UIFont {
        return font(size: 16)
    }

    var regular18: UIFont {
        return font(size: 18)
    }

    var regular24: UIFont {
        return font(size: 24)
    }

    var medium10: UIFont {
        return font(style: .medium, size: 10)
    }

    var medium12: UIFont {
        return font(style: .medium, size: 12)
    }

    var medium13: UIFont {
        return font(style: .medium, size: 13)
    }

    var medium14: UIFont {
        return font(style: .medium, size: 14)
    }

    var medium15: UIFont {
        return font(style: .medium, size: 15)
    }
    
    var medium16: UIFont {
        return font(style: .medium, size: 16)
    }

    var medium18: UIFont {
        return font(style: .medium, size: 18)
    }

    var medium20: UIFont {
        return font(style: .medium, size: 20)
    }

    var medium24: UIFont {
        return font(style: .medium, size: 24)
    }

    var semiBold12: UIFont {
        return font(style: .semiBold, size: 12)
    }

    var semiBold14: UIFont {
        return font(style: .semiBold, size: 14)
    }

    var semiBold16: UIFont {
        return font(style: .semiBold, size: 16)
    }

    var semiBold17: UIFont {
        return font(style: .semiBold, size: 17)
    }

    var semiBold20: UIFont {
        return font(style: .semiBold, size: 20)
    }
    
    var semiBold42: UIFont {
        return font(style: .semiBold, size: 42)
    }

    var bold10: UIFont {
        return font(style: .bold, size: 10)
    }

    var bold12: UIFont {
        return font(style: .bold, size: 12)
    }

    var bold14: UIFont {
        return font(style: .bold, size: 14)
    }

    var bold15: UIFont {
        return font(style: .bold, size: 15)
    }

    var bold16: UIFont {
        return font(style: .bold, size: 16)
    }

    var bold17: UIFont {
        return font(style: .bold, size: 17)
    }

    var bold18: UIFont {
        return font(style: .bold, size: 18)
    }

    var bold20: UIFont {
        return font(style: .bold, size: 20)
    }

    var bold24: UIFont {
        return font(style: .bold, size: 24)
    }

    var bold28: UIFont {
        return font(style: .bold, size: 28)
    }

    var bold30: UIFont {
        return font(style: .bold, size: 30)
    }

    var bold32: UIFont {
        return font(style: .bold, size: 32)
    }

    var bold40: UIFont {
        return font(style: .bold, size: 40)
    }

    var heavy12: UIFont {
        return font(style: .heavy, size: 12)
    }

    var heavy16: UIFont {
        return font(style: .heavy, size: 16)
    }

    var heavy18: UIFont {
        return font(style: .heavy, size: 18)
    }

    var extraBold10: UIFont {
        return font(style: .extraBold, size: 10)
    }

    var extraBold12: UIFont {
        return font(style: .extraBold, size: 12)
    }

    var extraBold14: UIFont {
        return font(style: .extraBold, size: 14)
    }

    var extraBold16: UIFont {
        return font(style: .extraBold, size: 16)
    }

    var extraBold17: UIFont {
        return font(style: .extraBold, size: 17)
    }

    var extraBold18: UIFont {
        return font(style: .extraBold, size: 18)
    }

    /* Font templates */
    var titleRegular: UIFont {
        return bold24
    }

    var agreementLabelFont: UIFont {
        return font(style: .medium, size: 13.2)
    }

    private func font(size: CGFloat) -> UIFont {
        return font(style: .regular, size: size)
    }

    private func font(style: FontStyle, size: CGFloat) -> UIFont {
        var name: String
        switch style {
        case .bold:
            name = "TTNorms-Bold"
        case .regular:
            name = "TTNorms-Regular"
        case .extraBold:
            name = "TTNorms-ExtraBold"
        case .semiBold:
            name = "TTNorms-Bold"
        case .medium:
            name = "TTNorms-Medium"
        case .light:
            name = "TTNorms-Light"
        case .heavy:
            name = "TTNorms-Black"
        }
        return UIFont(name: name, size: size)!
    }
}
