//
//  AddPaymentCardCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-28.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol AddPaymentCardCoordinatorDelegate: class {
    func didDismiss(in coordinator: AddPaymentCardCoordinator)
}

final class AddPaymentCardCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: AddPaymentCardViewController

    weak var delegate: AddPaymentCardCoordinatorDelegate?

    init(router: Router,
         rootViewController: AddPaymentCardViewController) {
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

extension AddPaymentCardCoordinator: AddPaymentCardViewControllerDelegate {

    func dismiss() {
        self.router.popModule()
        self.delegate?.didDismiss(in: self)
    }
}
