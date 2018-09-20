//
//  SelectAddressCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class SelectAddressCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []

    lazy var rootViewController: SelectAddressViewController = {
        let controller = SelectAddressViewController()
        controller.didSelectAddress = { location in
            print(location.address)
        }
        return controller
    }()

    init(router: Router) {
        self.router = router
        self.router.setNavigationBarStyle(style: .white)
    }

    func start() {
        self.router.setRootModule(rootViewController)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }

    func completeOnboarding() {
        self.router.dismissModule()
    }
}
