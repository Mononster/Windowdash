//
//  BrowseFoodTabCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class BrowseFoodTabCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: BrowseFoodViewController

    init(rootViewController: BrowseFoodViewController, router: Router) {
        self.router = router
        self.rootViewController = rootViewController
        self.rootViewController.delegate = self
    }

    func start() {
        self.router.setRootModule(rootViewController, hideBar: true)
        self.router.setNavigationBarStyle(style: .mainTheme)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}

extension BrowseFoodTabCoordinator: BrowseFoodViewControllerDelegate {

    func showCuisineAllStores(cuisine: BrowseFoodCuisineCategory) {
        let coordinator = CuisineAllStoresCoordinator(
            rootViewController: CuisineAllStoresViewController(cuisine: cuisine),
            router: self.router
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.push(coordinator, animated: true) {
            self.removeCoordinator(coordinator)
        }
    }

    func showCuratedCategoryAllStores(id: String, name: String, description: String?) {
        let viewModel = CuratedCategoryAllStoresViewModel(
            service: BrowseFoodAPIService(), id: id, name: name, description: description
        )
        let coordinator = CuratedCategoryAllStoresCoordinator(
            rootViewController: CuratedCategoryAllStoresViewController(viewModel: viewModel),
            router: self.router
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.push(coordinator, animated: true) {
            self.removeCoordinator(coordinator)
        }
    }

    func showDetailStorePage(id: String) {
        let coordinator = StoreDetailCoordinator(
            rootViewController: StoreDetailViewController(storeID: id),
            router: self.router
        )
        coordinator.start()
        addCoordinator(coordinator)
        self.router.push(coordinator, animated: true) {
            self.removeCoordinator(coordinator)
        }
    }
}
