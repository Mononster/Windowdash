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
    let loadingVC: LaunchLoadingViewController

    private var appTracker = AppTracker()
    var coordinators: [Coordinator] = []

    init(navigationController: DoorDashNavigationController,
         router: Router) {
        self.router = router
        self.navigationController = navigationController
        self.loadingVC = LaunchLoadingViewController()
        self.navigationController.navigationBar.isHidden = true
    }

    func start(window: UIWindow) {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        appTracker.start()
        show()
    }

    func showContents() {
        let coordinator = ContentCoordinator(
            router: Router(),
            appTracker: appTracker
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.present(coordinator)
    }

    func showOnboarding() {
        let coordinator = OnboardingCoordinator(router: Router())
        coordinator.delegate = self
        coordinator.start()
        addCoordinator(coordinator)
        self.router.present(coordinator, animated: false)
    }

    func showSelectAddress() {
        let coordinator = SelectAddressCoordinator(
            router: Router()
        )
        coordinator.start()
        addCoordinator(coordinator)
        coordinator.userDidFinishSelectingAddress = { coordinator in
            self.removeCoordinator(coordinator)
            self.showContents()
        }
        self.router.present(coordinator, animated: true)
    }

    func showLaunchLoadingScreen() {
        self.router.present(loadingVC, animated: false)
    }

    func dismissLaunchLoadingScreen() {
        self.router.dismissModule(animated: false)
    }

    func show() {
        guard let email = ApplicationEnvironment.current.currentUser?.email,
            let passwordToken = ApplicationEnvironment.current.passwordToken else {
            showOnboarding()
            return
        }
        let viewModel = SignupHomeViewModel(
            userAPI: UserAPIService(),
            dataStore: ApplicationEnvironment.current.dataStore
        )
        showLaunchLoadingScreen()
        viewModel.login(email: email, password: passwordToken.tokenStr) { (errorMsg) in
            self.dismissLaunchLoadingScreen()
            if let errorMsg = errorMsg {
                print(errorMsg)
                self.showOnboarding()
                return
            }
            if ApplicationEnvironment.current.currentUser?.defaultAddress == nil {
                self.showSelectAddress()
                return
            }
            self.showContents()
        }
    }
}

extension AppCoordinator {

    func handleNotifications() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }

    @objc func reset() {
        coordinators.removeAll()
        navigationController.dismiss(animated: true, completion: nil)
    }

    func didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: Data) {

    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnboarding(in coordinator: OnboardingCoordinator) {
        self.removeCoordinator(coordinator)
        if ApplicationEnvironment.current.currentUser?.defaultAddress == nil {
            self.showSelectAddress()
            return
        }
        self.showContents()
    }
}
