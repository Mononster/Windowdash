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
    let navigationController: DoorDashNavigationController

    private var appTracker = AppTracker()
    var coordinators: [Coordinator] = []

    init(navigationController: DoorDashNavigationController,
         router: Router) {
        self.router = router
        self.navigationController = navigationController
    }

    func start(window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        appTracker.start()
        showOnboarding()
        //showContents()
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

    func showOnboarding() {
        let coordinator = OnboardingCoordinator(router: Router())
        coordinator.delegate = self
        coordinator.start()
        addCoordinator(coordinator)
        self.router.present(coordinator, animated: false)
    }

    func handleNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    @objc func reset() {
        coordinators.removeAll()
        navigationController.dismiss(animated: true, completion: nil)
    }

    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {

    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didLoggedin(in coordinator: OnboardingCoordinator) {
        removeCoordinator(coordinator)
    }
}
