//
//  MainTabBarController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

typealias TabConfig = (String, UIImage)

protocol MainTabBarControllerDelegate: class {
    
}

class MainTabBarController: UITabBarController {

    static let maxHeight: CGFloat = 150
    static let minHeight: CGFloat = ApplicationDependency.manager.theme.tabBarHeight
    static var tabbarHeight: CGFloat = minHeight
    var cartView: CartThumbnailView?

    weak var tabBarDelegate: MainTabBarControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showCurrentlyPlaying()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setup() {
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        self.hidesBottomBarWhenPushed = false
        cartView = CartThumbnailView(copyFrom: tabBar)
        view.addSubview(cartView!)
        tabBar.isHidden = true
    }

    func setupTabItems() {
        cartView?.tabBar.items = tabBar.items
        cartView?.tabBar.selectedItem = tabBar.selectedItem
    }

    func hideCurrentlyPlaying() {
        MainTabBarController.tabbarHeight = MainTabBarController.minHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.cartView?.hideCartView()
            self.updateSelectedViewControllerLayout()
        })
    }
    func showCurrentlyPlaying() {
        MainTabBarController.tabbarHeight = MainTabBarController.maxHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.cartView?.showCartView()
            self.updateSelectedViewControllerLayout()
        })
    }

    func updateSelectedViewControllerLayout() {
        tabBar.sizeToFit()
        cartView?.sizeToFit()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        viewControllers?[self.selectedIndex].view.setNeedsLayout()
        viewControllers?[self.selectedIndex].view.layoutIfNeeded()
    }
}

