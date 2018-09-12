//
//  AppFont.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum FontSize {
    case small
    case regular
    case medium
    case large
    case custom(size: CGFloat)
}

enum FontStyle {
    case light
    case regular
    case medium
    case bold
    case heavy
}

protocol FontSchema {
    var smallBold: UIFont { get }
    var small: UIFont { get }
    var regular: UIFont { get }
    var regularBold: UIFont { get }
    var regularMedium: UIFont { get }
    var medium: UIFont { get }
    var mediumMedium: UIFont { get }
    var mediumBold: UIFont { get }
    var large: UIFont { get }
    var extraLargeMedium: UIFont { get }
    var largeMedium: UIFont { get }
    var navBarTitle: UIFont { get }
    var labelHeaderText: UIFont { get }
    var signupButtonText: UIFont { get }
    var signupTitleText: UIFont { get }
    var signupTextFieldInput: UIFont { get }
    var chatChannelInputTextViewFont: UIFont { get }
    var emojiSendButtonFont: UIFont { get }
    var priceBoldFont: UIFont { get }
    var statusTitleFont: UIFont { get }
    var expandableDetailDescriptionFont: UIFont { get }
    var expandableDescriptionTruncationTokenFont: UIFont { get }
    var timelineTitleFont: UIFont { get }
}

struct DefaultFontSchema: FontSchema {

    var smallBold: UIFont {
        return font(style: .bold, size: .small)
    }

    var small: UIFont {
        return font(size: .small)
    }

    var regular: UIFont {
        return font(size: .regular)
    }

    var regularMedium: UIFont {
        return font(style: .medium, size: .regular)
    }

    var regularBold: UIFont {
        return font(style: .bold, size: .regular)
    }

    var medium: UIFont {
        return font(size: .medium)
    }

    var mediumMedium: UIFont {
        return font(style: .medium, size: .medium)
    }

    var mediumBold: UIFont {
        return font(style: .bold, size: .medium)
    }

    var large: UIFont {
        return font(size: .large)
    }

    var extraLargeMedium: UIFont {
        return font(style: .medium, size: .custom(size: 22))
    }

    var largeMedium: UIFont {
        return font(style: .medium, size: .custom(size: 18))
    }

    var priceBoldFont: UIFont {
        return font(style: .bold, size: .custom(size: 19))
    }

    var navBarTitle: UIFont {
        return font(size: .medium)
    }

    var signupButtonText: UIFont {
        return font(size: .custom(size: 14.0))
    }

    var labelHeaderText: UIFont {
        return font(size: .custom(size: 14.0))
    }

    var signupTitleText: UIFont {
        return font(size: .custom(size: 24.0))
    }

    var signupTextFieldInput: UIFont {
        return font(size: .custom(size: 20.0))
    }

    var continueButtonText: UIFont {
        return font(size: .custom(size: 15.0))
    }

    var chatChannelInputTextViewFont: UIFont {
        return font(size: .custom(size: 17.0))
    }

    var emojiSendButtonFont: UIFont {
        return font(size: .custom(size: 14.0))
    }

    var statusTitleFont: UIFont {
        return font(style: .medium, size: .custom(size: 20))
    }

    var expandableDetailDescriptionFont: UIFont {
        return font(size: .custom(size: 15))
    }

    var expandableDescriptionTruncationTokenFont: UIFont {
        return font(size: .custom(size: 14))
    }

    var timelineTitleFont: UIFont {
        return font(style: .regular, size: .custom(size: 15))
    }

    private func font(size: FontSize) -> UIFont {
        return font(style: .regular, size: size)
    }

    private func font(style: FontStyle, size: FontSize) -> UIFont {
        var weight: UIFont.Weight
        switch style {
        case .bold:
            weight = .bold
        case .regular:
            weight = .regular
        case .medium:
            weight = .medium
        case .light:
            weight = .light
        case .heavy:
            weight = .heavy
        }

        var fontSize: CGFloat
        switch size {
        case .small:
            fontSize = 10.0
        case .regular:
            fontSize = 12.6
        case .medium:
            fontSize = 16.0
        case .large:
            fontSize = 19
        case .custom(let size):
            fontSize = size
        }
        return UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
}
