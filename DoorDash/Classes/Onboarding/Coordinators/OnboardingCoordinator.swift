//
//  OnboardingCoordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: class {
    func didFinishOnboarding(in coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []

    lazy var rootViewController: OnboardingViewController = {
        let controller = OnboardingViewController()
        controller.delegate = self
        return controller
    }()

    weak var delegate: OnboardingCoordinatorDelegate?

    init(router: Router) {
        self.router = router
        self.router.setNavigationBarStyle(style: .transparent)
    }

    func start() {
        self.rootViewController.delegate = self
        self.router.setRootModule(rootViewController, hideBar: true)
    }

    func toPresentable() -> UIViewController {
        return self.router.navigationController
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {

    func showLoginSignupViewController(mode: SignupMode) {
        let signupHomeViewController = SignupHomeViewController(mode: mode)
        signupHomeViewController.userCanProceedToNextStep = { _ in
            self.router.dismissModule(animated: true)
            self.delegate?.didFinishOnboarding(in: self)
        }
        self.router.push(signupHomeViewController)
    }
}



