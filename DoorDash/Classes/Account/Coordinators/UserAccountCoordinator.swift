//
//  UserAccountCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-22.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol UserAccountCoordinatorDelegate: class {
    func userLoggedOut()
}

final class UserAccountCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: UserAccountViewController

    weak var delegate: UserAccountCoordinatorDelegate?

    init(rootViewController: UserAccountViewController, router: Router) {
        self.router = router
        self.rootViewController = rootViewController
        rootViewController.delegate = self
    }

    func start() {
        self.router.setRootModule(rootViewController, hideBar: true)
        self.router.setNavigationBarStyle(style: .mainTheme)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}

extension UserAccountCoordinator: UserAccountViewControllerDelegate {

    func showSignupForGuestUser() {
        let signupHomeViewController = SignupHomeViewController(mode: .register)
        signupHomeViewController.userCanProceedToNextStep = { _ in
            self.router.dismissModule(animated: true, completion: {
                self.rootViewController.fetchUserProfile()
            })
        }
        self.router.present(signupHomeViewController, animated: true)
    }

    func userLoggedOut() {
        self.delegate?.userLoggedOut()
    }

    func showPageForType(type: UserAccountPageType) {
        switch type {
        case .paymentCards:
            let coordinator = PaymentMethodsCoordinator(
                rootViewController: PaymentMethodsViewController(style: .withCustomNavBar),
                router: self.router
            )
            coordinator.start()
            addCoordinator(coordinator)
            self.router.push(coordinator, animated: true) {
                self.removeCoordinator(coordinator)
            }
        default:
            break
        }
    }
}
