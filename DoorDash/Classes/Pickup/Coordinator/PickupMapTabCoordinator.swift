//
//  PickupMapTabCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class PickupMapTabCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: PickupMapViewController

    init(rootViewController: PickupMapViewController, router: Router) {
        self.router = router
        self.rootViewController = rootViewController
    }

    func start() {
        rootViewController.delegate = self
        router.setRootModule(rootViewController)
        router.setNavigationBarStyle(style: .mainTheme)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}

extension PickupMapTabCoordinator: PickupMapViewControllerDelegate {

}

