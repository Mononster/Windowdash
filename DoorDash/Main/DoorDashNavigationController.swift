//
//  DoorDashNavigationController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class DoorDashNavigationController: UINavigationController {

    enum NavigationBarStyle {
        case mainTheme
        case white
        case transparent
    }

    var navigationBarStyle: NavigationBarStyle = .mainTheme {
        didSet {
            let theme = ApplicationDependency.manager.theme
            var titleColor: UIColor
            switch navigationBarStyle {
            case .transparent:
                self.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationBar.shadowImage = UIImage()
                self.navigationBar.tintColor = theme.colors.white
                self.navigationBar.isTranslucent = true
                titleColor = UIColor.clear
            case .white:
                self.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationBar.shadowImage = nil
                self.navigationBar.tintColor = theme.colors.darkGray
                self.navigationBar.isTranslucent = false
                self.navigationBar.barTintColor = theme.colors.white
                titleColor = theme.colors.black
            case .mainTheme:
                self.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationBar.shadowImage = nil
                self.navigationBar.tintColor = theme.colors.doorDashRed
                self.navigationBar.isTranslucent = false
                self.navigationBar.barTintColor = theme.colors.white
                titleColor = theme.colors.black
            }
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.font: theme.fontSchema.medium18]
        }
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }
}
