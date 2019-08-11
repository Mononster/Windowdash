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
    var tabbarImages: [String] { get }
    var mapPinImage: UIImage { get }
    var rightArrowImage: UIImage { get }
    var grayRoundBackground: UIImage { get }
    var grayRectBackground: UIImage { get }
    var rightArrowViewAll: UIImage { get }
    var starHighlighted: UIImage { get }
    var starDarkGray: UIImage { get }
    var ratingStarFull: UIImage { get }
    var ratingStarEmpty: UIImage { get }
    var backTriangleIcon: UIImage { get }
    var backRoundIcon: UIImage { get }
    var buttonCheckmark: UIImage { get }
    var addItemIcon: UIImage { get }
    var minusItemIcon: UIImage { get }
    var addItemUnselectedIcon: UIImage { get }
    var minusItemUnselecetedIcon: UIImage { get }
    var blackCircleInfoIcon: UIImage { get }
    var lightgrayInfoIcon: UIImage { get }
    var redCheckMark: UIImage { get }
    var dropDownIndicator: UIImage { get }
    var orderCartIcon: UIImage { get }
    var dismissIcon: UIImage { get }
    var storePinNormal: UIImage { get }
    var storePinSelected: UIImage { get }
    var myLocationImage: UIImage { get }
    var mapIcon: UIImage { get }
    var listIcon: UIImage { get }
    var searchIcon: UIImage { get }
    var houseIcon: UIImage { get }
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

    var tabbarImages: [String] {
        return ["tabbar_new_1", "tabbar_new_2", "tabbar_new_3", "tabbar_new_4", "tabbar_new_5"]
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

    var rightArrowViewAll: UIImage {
        return UIImage(named: "right_arrow_view_all_button")!
    }

    var starHighlighted: UIImage {
        return UIImage(named: "star_highlighted")!
    }

    var starDarkGray: UIImage {
        return UIImage(named: "star_unhighlighted")!
    }

    var ratingStarFull: UIImage {
        return UIImage(named: "rating_star_full")!
    }

    var ratingStarEmpty: UIImage {
        return UIImage(named: "rating_star_empty")!
    }

    var backTriangleIcon: UIImage {
        return UIImage(named: "back_triangle")!
    }

    var backRoundIcon: UIImage {
        return UIImage(named: "back_round")!
    }

    var buttonCheckmark: UIImage {
        return UIImage(named: "button_checkmark")!
    }

    var addItemIcon: UIImage {
        return UIImage(named: "add_item")!
    }

    var minusItemIcon: UIImage {
        return UIImage(named: "minus_item")!
    }

    var addItemUnselectedIcon: UIImage {
        return UIImage(named: "add_item_unselected")!
    }

    var minusItemUnselecetedIcon: UIImage {
        return UIImage(named: "minus_item_unselected")!
    }

    var blackCircleInfoIcon: UIImage {
        return UIImage(named: "black_circle_info")!
    }

    var lightgrayInfoIcon: UIImage {
        return UIImage(named: "lightgray_circle_info")!
    }

    var redCheckMark: UIImage {
        return UIImage(named: "right_checkmark")!
    }

    var dropDownIndicator: UIImage {
        return UIImage(named: "drop_down_triangle")!
    }

    var orderCartIcon: UIImage {
        return UIImage(named: "order_cart")!
    }

    var dismissIcon: UIImage {
        return UIImage(named: "icon_close_grey")!
    }

    var storePinNormal: UIImage {
        return UIImage(named: "map_pin_normal")!
    }

    var storePinSelected: UIImage {
        return UIImage(named: "map_pin_selected")!
    }

    var myLocationImage: UIImage {
        return UIImage(named: "my_location")!
    }

    var mapIcon: UIImage {
        return UIImage(named: "map_icon")!
    }

    var listIcon: UIImage {
        return UIImage(named: "list_icon")!
    }

    var searchIcon: UIImage {
        return UIImage(named: "search_icon")!
    }

    var houseIcon: UIImage {
        return UIImage(named: "house_icon")!
    }
}
