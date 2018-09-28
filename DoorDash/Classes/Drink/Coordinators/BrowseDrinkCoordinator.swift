//
//  BrowseDrinkCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class BrowseDrinkCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: BrowseDrinkViewController

    init(rootViewController: BrowseDrinkViewController, router: Router) {
        self.router = router
        self.rootViewController = rootViewController
    }

    func start() {
        self.router.setRootModule(rootViewController, hideBar: true)
        self.router.setNavigationBarStyle(style: .mainTheme)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}
