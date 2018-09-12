//
//  ContentCoordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class ContentCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    var tabConfigs: [TabConfig] = []
    let appTracker: AppTracker

    let numOfChildren = 5
    let childrenTitle = ["Home", "Match", "Post", "Chat", "Me"]

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

    func setupTabConfigs() {
        let imageTheme = ApplicationDependency.manager.theme.imageAssets
        tabConfigs.append((BounceContentView(), childrenTitle[0], imageTheme.tabBarHomeNormal, imageTheme.tabBarHomeSelected))
        tabConfigs.append((BounceContentView(), childrenTitle[1], imageTheme.tabBarDiscoverNormal, imageTheme.tabBarDiscoverSelected))
        tabConfigs.append((IrregularityContentView(), childrenTitle[2], imageTheme.tabBarComposeAddIcon, imageTheme.tabBarComposeAddIcon))
        tabConfigs.append((BounceContentView(), childrenTitle[3], imageTheme.tabBarMessageNormal, imageTheme.tabBarMessageSelected))
        tabConfigs.append((BounceContentView(), childrenTitle[4], imageTheme.tabBarProfileNormal, imageTheme.tabBarProfileSelected))
    }

    func setupTabbar() {
        let v1 = HomeViewController()
        let v2 = DiscoverViewController()
        let v3 = UIViewController()
        let v4 = MessageViewController()
        let v5 = ProfileHomeViewController()
        let controllers = [v1, v2, v3, v4, v5]

        for (index, vc) in controllers.enumerated(){
            let config = tabConfigs[index]
            vc.tabBarItem = ESTabBarItem.init(config.0, title: config.1, image: config.2, selectedImage: config.3)
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            vc.navigationItem.title = config.1
        }

        let homeTabCoordinator = HomeTabCoordinator(
            rootViewController: v1,
            router: Router()
        )
        homeTabCoordinator.start()
        addCoordinator(homeTabCoordinator)

        let discoverTabCoordinator = DiscoverTabCoordinator(
            rootViewController: v2,
            router: Router()
        )
        discoverTabCoordinator.start()
        addCoordinator(discoverTabCoordinator)

        let messageTabCoordinator = MessageTabCoordinator(
            rootViewController: v4,
            router: Router()
        )
        messageTabCoordinator.start()
        addCoordinator(messageTabCoordinator)

        let profileTabCoordinator = ProfileTabCoordinator(
            rootViewController: v5,
            router: Router()
        )
        profileTabCoordinator.start()
        addCoordinator(profileTabCoordinator)

        let tabBarController = MainTabBarController()
        tabBarController.tabBarDelegate = self
        tabBarController.viewControllers = [
            homeTabCoordinator.toPresentable(),
            discoverTabCoordinator.toPresentable(),
            v3,
            messageTabCoordinator.toPresentable(),
            profileTabCoordinator.toPresentable()
        ]

        self.router.setRootModule(tabBarController, hideBar: true)
    }
}

extension ContentCoordinator: MainTabBarControllerDelegate {

    func startPostingCoordinator() {
        let postTabCoordinator = PostTabCoordinator(
            rootViewController: PostStatusMainViewController(),
            router: Router()
        )
        postTabCoordinator.delegate = self
        postTabCoordinator.start()
        addCoordinator(postTabCoordinator)
        self.router.present(postTabCoordinator, animated: true)
    }
}

extension ContentCoordinator: PostTabCoordinatorDelegate {
    func didCancel(in coordinator: PostTabCoordinator) {
        removeCoordinator(coordinator)
    }
}
