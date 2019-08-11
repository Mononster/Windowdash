//
//  PaymentMethodsCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol PaymentMethodsCoordinatorDelegate: class {
    func didDismiss(in coordinator: PaymentMethodsCoordinator)
}

final class PaymentMethodsCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: PaymentMethodsViewController

    weak var delegate: PaymentMethodsCoordinatorDelegate?

    init(rootViewController: PaymentMethodsViewController,
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

extension PaymentMethodsCoordinator: PaymentMethodsViewControllerDelegate {

    func dismiss() {
        self.router.popModule()
    }

    func showAddCardModule() {
        let coordinator = AddPaymentCardCoordinator(
            router: self.router,
            rootViewController: AddPaymentCardViewController(style: rootViewController.style)
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.push(coordinator, animated: true) {
            self.removeCoordinator(coordinator)
        }
    }
}
