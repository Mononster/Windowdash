//
//  ApplicationDependency.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class ApplicationDependency {

    static let manager = ApplicationDependency()
    static var safeAreaPadding: CGFloat = 0

    let theme = Theme()
    lazy var coordinator: AppCoordinator = {
        let navigationController = DoorDashNavigationController()
        let router = Router(navigationController: navigationController)
        return AppCoordinator(navigationController: navigationController,
                              router: router)
    }()

    private init() {
        if #available(iOS 11.0, *) {
            ApplicationDependency.safeAreaPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
    }
}
