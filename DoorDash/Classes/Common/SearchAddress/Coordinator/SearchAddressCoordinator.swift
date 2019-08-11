//
//  SearchAddressCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol SearchAddressCoordinatorDelegate: class {
    func didDismiss(in coordinator: Coordinator)
    func didChangedAddress()
}

final class SearchAddressCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: SearchAddressViewController

    weak var delegate: SearchAddressCoordinatorDelegate?

    init(router: Router) {
        self.router = router
        self.router.setNavigationBarStyle(style: .white)
        let presenter = SearchAddressPresenter()
        let interactor = SearchAddressInteractor(presenter: presenter, apiService: UserAPIService())
        rootViewController = SearchAddressViewController(interactor: interactor)
        presenter.output = rootViewController
    }

    func start() {
        router.setRootModule(rootViewController)
        rootViewController.delegate = self
    }

    func toPresentable() -> UIViewController {
        return router.navigationController
    }
}

extension SearchAddressCoordinator: SearchAddressViewControllerDelegate {

    func didChangedAddress() {
        dismiss()
        delegate?.didChangedAddress()
    }

    func dismiss() {
        router.dismissModule()
        delegate?.didDismiss(in: self)
    }
}
