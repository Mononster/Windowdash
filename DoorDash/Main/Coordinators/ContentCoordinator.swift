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
    private let childrenTitle = ["Delivery", "Pickup", "Search", "Orders", "Account"]

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
            let imageName = imageTheme.tabbarImages[i]
            tabConfigs.append((title, UIImage(named: imageName)!, UIImage(named: imageName + "_selected")!))
        }
    }

    private func generatePickupMapModule() -> PickupMapViewController {
        let presenter = PickupMapPresenter()
        let interactor = PickupMapInteractor(presenter: presenter, apiService: BrowseFoodAPIService())
        let vc = PickupMapViewController(interactor: interactor)
        presenter.output = vc
        return vc
    }

    private func setupTabbar() {
        let v1 = BrowseFoodViewController()
        let v2 = generatePickupMapModule()
        let v3 = UIViewController()
        let v4 = UIViewController()
        let v5 = UserAccountViewController()
        let controllers = [v1, v2, v3, v4, v5]
        for (index, vc) in controllers.enumerated(){
            let config = tabConfigs[index]
            vc.navigationItem.title = config.title
            vc.tabBarItem.image = config.image.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.selectedImage = config.selectedImage.withRenderingMode(.alwaysOriginal)
            vc.tabBarItem.title = config.0
            vc.tabBarItem.setTitleTextAttributes(
                [NSAttributedString.Key.font: ApplicationDependency.manager.theme.fonts.medium12,
                 NSAttributedString.Key.foregroundColor:
                    ApplicationDependency.manager.theme.colors.doorDashGray
                ],
                for: .normal
            )
            vc.tabBarItem.setTitleTextAttributes(
                [NSAttributedString.Key.font: ApplicationDependency.manager.theme.fonts.medium16,
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

        let browseDrinkCoordinator = PickupMapTabCoordinator(
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
    }
}

extension ContentCoordinator: MainTabBarControllerDelegate {
    func showOrderCart() {
        let orderCartCoordinator = OrderCartCoordinator(
            rootViewController: OrderCartViewController(),
            router: Router()
        )
        orderCartCoordinator.start()
        orderCartCoordinator.delegate = self
        addCoordinator(orderCartCoordinator)
        self.router.present(orderCartCoordinator)
    }
}

extension ContentCoordinator: OrderCartCoordinatorDelegate {
    func didDismiss(in coordinator: OrderCartCoordinator) {
        self.removeCoordinator(coordinator)
    }
}

extension ContentCoordinator: UserAccountCoordinatorDelegate {

    func userLoggedOut() {
        self.router.dismissModule(animated: true)
        self.delegate?.restartApp(in: self)
    }
}
