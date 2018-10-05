//
//  CartThumbnailView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-04.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class CartThumbnailView: UIView {

    var isCartHidden = false
    let tabBar: UITabBar
    let cartView: UIView

    override init(frame: CGRect) {
        tabBar = UITabBar()
        cartView = UIView()
        super.init(frame: frame)
        setupUI()
    }

    convenience init(copyFrom tabBar: UITabBar) {
        self.init(frame: tabBar.frame)
        self.tabBar.backgroundColor = tabBar.backgroundColor
        self.tabBar.tintColor = tabBar.tintColor
        self.tabBar.unselectedItemTintColor = tabBar.unselectedItemTintColor
        self.tabBar.isTranslucent = tabBar.isTranslucent
        self.tabBar.barStyle = tabBar.barStyle
        self.tabBar.barTintColor = tabBar.barTintColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hideCartView() {
        isCartHidden = true
        cartView.alpha = 0
        let newY = frame.origin.y
            + CGFloat(MainTabBarController.maxHeight)
            - CGFloat(MainTabBarController.minHeight)
        frame = CGRect(x: 0, y: newY, width: frame.width, height: CGFloat(MainTabBarController.maxHeight))
    }

    func showCartView() {
        isCartHidden = false
        cartView.alpha = 1
        let newY = frame.origin.y
            - CGFloat(MainTabBarController.maxHeight)
            + CGFloat(MainTabBarController.minHeight)
        frame = CGRect(x: 0, y: newY, width: frame.width, height: CGFloat(MainTabBarController.maxHeight))
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = tabBar.sizeThatFits(size)
        sizeThatFits.height = CGFloat(isCartHidden ? MainTabBarController.minHeight : MainTabBarController.maxHeight)
        return sizeThatFits
    }
}

extension CartThumbnailView {

    private func setupUI() {
        setupTabbar()
        setupCartView()
        setupConstratins()
    }

    private func setupTabbar() {
        addSubview(tabBar)
    }

    private func setupCartView() {
        addSubview(cartView)
        cartView.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
    }

    private func setupConstratins() {
        cartView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }

        tabBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(ApplicationDependency.manager.theme.tabBarHeight)
        }
    }
}
