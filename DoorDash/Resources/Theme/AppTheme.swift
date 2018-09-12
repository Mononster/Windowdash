//
//  AppTheme.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

struct Theme {
    let colors: ColorSchema
    let imageAssets: ImageAsset
    let fontSchema: FontSchema

    let navigationBarHeight: CGFloat
    let tabBarHeight: CGFloat

    init(colors: ColorSchema = DefaultColors(),
         imageAssets: ImageAsset = DefaultImageAsset(),
         fontSchema: FontSchema = DefaultFontSchema()) {
        self.colors = colors
        self.imageAssets = imageAssets
        self.fontSchema = fontSchema

        let device = Device()
        self.navigationBarHeight = device == .iPhoneX ? 88 : 64
        self.tabBarHeight = device == .iPhoneX ? 83 : 49
    }
}

extension Theme {

    func navigationBarAppearance(type: MainNavigationController.NavigationBarStyle) {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = colors.uwLifeRed
        var titleColor: UIColor
        switch type {
        case .mainTheme:
            appearance.tintColor = colors.white
            titleColor = colors.white
            appearance.isTranslucent = false
        case .transparent:
            appearance.tintColor = colors.uwLifeRed
            titleColor = UIColor.clear
            appearance.isTranslucent = true
        case .white:
            appearance.tintColor = colors.white
            titleColor = colors.darkGray
            appearance.isTranslucent = false
        }
        appearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor, NSAttributedStringKey.font: fontSchema.navBarTitle]
    }
}
