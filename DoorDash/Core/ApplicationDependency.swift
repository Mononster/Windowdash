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
    var safeAreaPadding: CGFloat = 0

    let theme = Theme()
    let cartThumbnailViewHeight: CGFloat = 50

    lazy var coordinator: AppCoordinator = {
        let navigationController = DoorDashNavigationController()
        let router = Router(navigationController: navigationController)
        return AppCoordinator(navigationController: navigationController,
                              router: router)
    }()

    lazy var cartManager: CartManager = {
        return CartManager()
    }()

    lazy var isEmptyCart: Bool = {
        guard let mainTabbarVC = coordinator.getMainTabbarController() else {
            return true
        }
        return mainTabbarVC.viewModel.cartViewModel?.isEmptyCart ?? true
    }()

    private init() {
        if #available(iOS 11.0, *) {
            safeAreaPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
    }

    func informMainTabbarVCUpdateCart() {
        guard let mainTabbarVC = coordinator.getMainTabbarController() else {
            return
        }
        mainTabbarVC.loadData()
    }

    func cleanWhenUserLogout() {
        cartManager.removeCartInfoFromUserDefaults()
    }
}
