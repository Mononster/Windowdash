//
//  MainTabBarController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

typealias TabConfig = (String, UIImage)

protocol MainTabBarControllerDelegate: class {
    
}

class MainTabBarController: UITabBarController {

    weak var tabBarDelegate: MainTabBarControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        self.hidesBottomBarWhenPushed = false
        setup()
    }

    private func setup() {

    }
}
