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

    var userDidFinishSelectingAddress: ((Coordinator) -> ())?

    lazy var rootViewController: SelectAddressViewController = {
        let controller = SelectAddressViewController()
        controller.didSelectAddress = { location in
            print(location.address)
            self.toConfirmAdressViewController(location: location)
        }
        return controller
    }()

    var confirmAddressViewController: ConfirmAddressViewController?

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

    func toConfirmAdressViewController(location: GMDetailLocation) {
        confirmAddressViewController = ConfirmAddressViewController(location: location)
        confirmAddressViewController?.delegate = self
        self.router.push(confirmAddressViewController!)
    }

    func toRefineLocationViewController(viewModel: ConfirmAddressViewModel) {
        let refineLocationViewController = RefineLocationViewController(viewModel: viewModel)
        refineLocationViewController.didSaveAddress = {
            self.router.popModule()
            self.confirmAddressViewController?.refreshUI()
        }
        self.router.push(refineLocationViewController)
    }
}

extension SelectAddressCoordinator: ConfirmAddressViewControllerDelegate {
    
    func userTappedRefineLocation(viewModel: ConfirmAddressViewModel) {
        toRefineLocationViewController(viewModel: viewModel)
    }

    func userTappedConfirmButton() {
        self.router.dismissModule(animated: true) {
            self.userDidFinishSelectingAddress?(self)
        }
    }
}
