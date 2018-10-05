//
//  ContentCoordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol ContentCoordinatorDelegate: class {
    func restartApp(in coordinator: ContentCoordinator)
}

final class ContentCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    weak var delegate: ContentCoordinatorDelegate?

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
        let v2 = BrowseDrinkViewController()
        let v3 = UIViewController()
        let v4 = UIViewController()
        let v5 = UserAccountViewController()
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

        let browseDrinkCoordinator = BrowseDrinkCoordinator(
            rootViewController: v2,
            router: Router()
        )
        browseDrinkCoordinator.start()
        addCoordinator(browseDrinkCoordinator)
//
//        let messageTabCoordinator = MessageTabCoordinator(
//            rootViewController: v4,
//            router: Router()
//        )
//        messageTabCoordinator.start()
//        addCoordinator(messageTabCoordinator)
//
        let userAccountTabCoordinator = UserAccountCoordinator(
            rootViewController: v5,
            router: Router()
        )
        userAccountTabCoordinator.start()
        userAccountTabCoordinator.delegate = self
        addCoordinator(userAccountTabCoordinator)

        let tabBarController = MainTabBarController()
        tabBarController.tabBarDelegate = self
        tabBarController.viewControllers = [
            browseFoodTabCoordinator.toPresentable(),
            browseDrinkCoordinator.toPresentable(),
            v3,
            v4,
            userAccountTabCoordinator.toPresentable()
        ]
        self.router.setRootModule(tabBarController, hideBar: true)
        tabBarController.setupTabItems()
    }
}

extension ContentCoordinator: MainTabBarControllerDelegate {

}

extension ContentCoordinator: UserAccountCoordinatorDelegate {

    func userLoggedOut() {
        self.router.dismissModule(animated: true)
        self.delegate?.restartApp(in: self)
    }
}
