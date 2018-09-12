//
//  AppCoordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    let router: Router
    let navigationController: MainNavigationController

    private var appTracker = AppTracker()
    var coordinators: [Coordinator] = []

    init(navigationController: MainNavigationController,
         router: Router) {
        self.router = router
        self.navigationController = navigationController
    }

    func start(window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        appTracker.start()
        resetToWelcomeScreen()
        showContents()
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }

    func showContents() {
        let coordinator = ContentCoordinator(
            router: router,
            appTracker: appTracker
        )
        coordinator.start()
        addCoordinator(coordinator)
    }

    func handleNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func resetToWelcomeScreen() {

    }

    @objc func reset() {
        coordinators.removeAll()
        navigationController.dismiss(animated: true, completion: nil)
        resetToWelcomeScreen()
    }

    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {

    }
}
