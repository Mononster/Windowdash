//
//  MainNavigationController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

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
                titleColor = theme.colors.darkGray
            case .mainTheme:
                self.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationBar.shadowImage = nil
                self.navigationBar.tintColor = theme.colors.uwLifeRed
                self.navigationBar.isTranslucent = false
                self.navigationBar.barTintColor = theme.colors.black
                titleColor = theme.colors.white
            }
            self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor, NSAttributedStringKey.font: theme.fontSchema.navBarTitle]
        }
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        switch navigationBarStyle {
//        case .mainTheme:
//            return .lightContent
//        case .transparent, .white:
//            return .default
//        }
//    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }
}
