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
        self.router.setNavigationBarStyle(style: .mainTheme)
        self.router.setRootModule(rootViewController)
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

    func presentStorePage(storeID: String) {
        let coordinator = StoreDetailCoordinator(
            rootViewController: StoreDetailViewController(storeID: storeID, style: .nativeNavBar),
            router: self.router
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.push(coordinator, animated: true) {
            self.removeCoordinator(coordinator)
        }
    }

    func presentCheckoutPage() {
        let coordinator = CheckoutCoordinator(
            rootViewController: CheckoutViewController(),
            router: self.router
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.push(coordinator, animated: true) {
            self.removeCoordinator(coordinator)
        }
    }

    func presentItemDetailPage(itemID: String,
                               storeID: String,
                               selectedData: ItemSelectedData?) {
        let coordinator = ItemDetailInfoCoordinator(
            rootViewController: ItemDetailInfoViewController(itemID: itemID, storeID: storeID, mode: .fromCart, selectedData: selectedData),
            router: Router()
        )
        coordinator.start()
        coordinator.delegate = self
        addCoordinator(coordinator)
        self.router.present(coordinator)
    }
}

extension OrderCartCoordinator: ItemDetailInfoCoordinatorDelegate {

    func didDismiss(in coordinator: ItemDetailInfoCoordinator) {
        self.removeCoordinator(coordinator)
    }
}
