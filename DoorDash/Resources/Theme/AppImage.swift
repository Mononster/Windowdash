//
//  AppImage.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol ImageAsset {
    var logoImage: UIImage { get }
    var logoNoText: UIImage { get }
    var facebook: UIImage { get }
    var google: UIImage { get }
    var onboardingImages: [UIImage] { get }
    var tabbarImages: [UIImage] { get }
    var mapPinImage: UIImage { get }
    var rightArrowImage: UIImage { get }
    var grayRoundBackground: UIImage { get }
    var grayRectBackground: UIImage { get }
}

struct DefaultImageAsset: ImageAsset {

    var logoImage: UIImage {
        return #imageLiteral(resourceName: "doordash_logo")
    }

    var logoNoText: UIImage {
        return #imageLiteral(resourceName: "logo_no_text")
    }

    var facebook: UIImage {
        return #imageLiteral(resourceName: "icon_facebook")
    }

    var google: UIImage {
        return #imageLiteral(resourceName: "icon_google")
    }

    var onboardingImages: [UIImage] {
        return [#imageLiteral(resourceName: "onboarding1"), #imageLiteral(resourceName: "onboarding2"), #imageLiteral(resourceName: "onboarding3"), #imageLiteral(resourceName: "onboarding4"), #imageLiteral(resourceName: "onboarding5")]
    }
    var tabbarImages: [UIImage] {
        return [#imageLiteral(resourceName: "tabbar_1"), #imageLiteral(resourceName: "tabbar_2"), #imageLiteral(resourceName: "tabbar_3"), #imageLiteral(resourceName: "tabbar_4"), #imageLiteral(resourceName: "tabbar_5")]
    }

    var mapPinImage: UIImage {
        return #imageLiteral(resourceName: "map_pin")
    }

    var rightArrowImage: UIImage {
        return #imageLiteral(resourceName: "right_arrow")
    }

    var grayRoundBackground: UIImage {
        return #imageLiteral(resourceName: "gray_round_background")
    }

    var grayRectBackground: UIImage {
        return #imageLiteral(resourceName: "gray_rect_background")
    }
}
