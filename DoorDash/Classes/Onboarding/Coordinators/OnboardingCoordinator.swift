//
//  OnboardingCoordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: class {
    func didLoggedin(in coordinator: OnboardingCoordinator)
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

    func completeOnboarding() {
        self.router.dismissModule()
        delegate?.didLoggedin(in: self)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {

    func showLoginSignupViewController(mode: SignupMode) {
        self.router.push(SignupHomeViewController(mode: mode))
    }
}



