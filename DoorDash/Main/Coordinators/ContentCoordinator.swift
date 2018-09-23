//
//  ContentCoordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class ContentCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []

    private var tabConfigs: [TabConfig] = []
    private let appTracker: AppTracker
    private let numOfChildren = 5
    private let childrenTitle = ["Food", "Drinks", "Search", "Orders", "Account"]

    var tabBarController: MainTabBarController? {
        return self.router.rootViewController as? MainTabBarController
    }

    init(router: Router,
         appTracker: AppTracker = AppTracker()) {
        self.router = router
        self.appTracker = appTracker
        setupTabConfigs()
    }

    func start() {
        setupTabbar()
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}

extension ContentCoordinator {

    private func setupTabConfigs() {
        let imageTheme = ApplicationDependency.manager.theme.imageAssets
        for (i, title) in childrenTitle.enumerated() {
            tabConfigs.append((title, imageTheme.tabbarImages[i]))
        }
    }

    private func setupTabbar() {
        let v1 = BrowseFoodViewController()
        let v2 = UIViewController()
        let v3 = UIViewController()
        let v4 = UIViewController()
        let v5 = UIViewController()
        let controllers = [v1, v2, v3, v4, v5]
        for (index, vc) in controllers.enumerated(){
            let config = tabConfigs[index]
            vc.navigationItem.title = config.0
            vc.tabBarItem.image = config.1
            vc.tabBarItem.title = config.0
            vc.tabBarItem.setTitleTextAttributes(
                [NSAttributedString.Key.font: ApplicationDependency.manager.theme.fontSchema.medium12,
                 NSAttributedString.Key.foregroundColor:
                    ApplicationDependency.manager.theme.colors.doorDashGray
                ],
                for: .normal
            )
            vc.tabBarItem.setTitleTextAttributes(
                [NSAttributedString.Key.font: ApplicationDependency.manager.theme.fontSchema.medium16,
                 NSAttributedString.Key.foregroundColor:
                    ApplicationDependency.manager.theme.colors.doorDashRed
                ],
                for: .selected
            )
        }

        let browseFoodTabCoordinator = BrowseFoodTabCoordinator(
            rootViewController: v1,
            router: Router()
        )
        browseFoodTabCoordinator.start()
        addCoordinator(browseFoodTabCoordinator)
//
//        let discoverTabCoordinator = DiscoverTabCoordinator(
//            rootViewController: v2,
//            router: Router()
//        )
//        discoverTabCoordinator.start()
//        addCoordinator(discoverTabCoordinator)
//
//        let messageTabCoordinator = MessageTabCoordinator(
//            rootViewController: v4,
//            router: Router()
//        )
//        messageTabCoordinator.start()
//        addCoordinator(messageTabCoordinator)
//
//        let profileTabCoordinator = ProfileTabCoordinator(
//            rootViewController: v5,
//            router: Router()
//        )
//        profileTabCoordinator.start()
//        addCoordinator(profileTabCoordinator)

        let tabBarController = MainTabBarController()
        tabBarController.tabBarDelegate = self
        tabBarController.viewControllers = [
            browseFoodTabCoordinator.toPresentable(),
            v2,
            v3,
            v4,
            v5
        ]
        self.router.setRootModule(tabBarController, hideBar: true)
    }
}

extension ContentCoordinator: MainTabBarControllerDelegate {

}
