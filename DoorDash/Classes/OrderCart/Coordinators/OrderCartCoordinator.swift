//
//  OrderCartCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol OrderCartCoordinatorDelegate: class {
    func didDismiss(in coordinator: OrderCartCoordinator)
}

final class OrderCartCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: OrderCartViewController

    weak var delegate: OrderCartCoordinatorDelegate?

    init(rootViewController: OrderCartViewController,
         router: Router) {
        self.router = router
        self.rootViewController = rootViewController
    }

    func start() {
        self.rootViewController.delegate = self
        self.router.setRootModule(rootViewController, hideBar: true)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}

extension OrderCartCoordinator: OrderCartViewControllerDelegate {

    func dismiss() {
        self.router.dismissModule()
        self.delegate?.didDismiss(in: self)
    }
}

