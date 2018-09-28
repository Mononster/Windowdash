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

        self.navigationBarHeight = UIDevice.current.hasNotch ? 88 : 64
        self.tabBarHeight = UIDevice.current.hasNotch ? 83 : 49
    }
}

extension Theme {

    func navigationBarAppearance(type: NavigationBarStyle) {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = colors.doorDashRed
        var titleColor: UIColor
        switch type {
        case .mainTheme:
            appearance.tintColor = colors.white
            titleColor = colors.white
            appearance.isTranslucent = false
        case .transparent:
            appearance.tintColor = colors.doorDashRed
            titleColor = UIColor.clear
            appearance.isTranslucent = true
        case .white:
            appearance.tintColor = colors.white
            titleColor = colors.darkGray
            appearance.isTranslucent = false
        }
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.font: fontSchema.medium14]
    }
}
