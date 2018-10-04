//
//  StoreDetailCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class StoreDetailCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: StoreDetailViewController

    init(rootViewController: StoreDetailViewController,
         router: Router) {
        self.router = router
        self.rootViewController = rootViewController
    }

    func start() {
        self.rootViewController.delegate = self
    }

    func toPresentable() -> UIViewController {
        return self.rootViewController
    }
}

extension StoreDetailCoordinator: StoreDetailViewControllerDelegate {

    func dismiss() {
        self.router.popModule()
    }
}
