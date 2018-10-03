//
//  CuisineAllStoresCoordinator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-27.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class CuisineAllStoresCoordinator: Coordinator {

    let router: Router
    var coordinators: [Coordinator] = []
    let rootViewController: CuisineAllStoresViewController

    init(rootViewController: CuisineAllStoresViewController, router: Router) {
        self.router = router
        self.rootViewController = rootViewController
    }

    func start() {

    }

    func toPresentable() -> UIViewController {
        return self.rootViewController
    }
}
