//
//  MainTabBarController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

typealias TabConfig = (ESTabBarItemContentView, String, UIImage, UIImage)

protocol MainTabBarControllerDelegate: class {
    func startPostingCoordinator()
}

class MainTabBarController: ESTabBarController {

    weak var tabBarDelegate: MainTabBarControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        setup()
    }

    private func setup() {
        shouldHijackHandler = { _, _, index in
            if index == 2 {
                return true
            }
            return false
        }

        didHijackHandler = { _, _, _ in
            self.tabBarDelegate?.startPostingCoordinator()
        }
    }
}
