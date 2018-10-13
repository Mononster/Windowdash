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
    func showOrderCart()
}

final class MainTabBarController: UITabBarController {

    weak var tabBarDelegate: MainTabBarControllerDelegate?
    private let cartThumbnailView: OrderCartThumbnailView
    let viewModel: MainTabBarViewModel

    init() {
        cartThumbnailView = OrderCartThumbnailView(frame: .zero)
        viewModel = MainTabBarViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }

    func loadData() {
        viewModel.fetchCurrentCart { (errorMsg) in
            if let error = errorMsg {
                // TODO: This is bad if we got error when fetching cart,
                // considering send request again.
                log.error(error)
                return
            }
            guard let cartVM = self.viewModel.cartViewModel else {
                return
            }
            if !cartVM.isEmptyCart {
                self.cartThumbnailView.setupText(description: cartVM.storeNameAndQuantityDisplay)
                if self.cartThumbnailView.isHidden {
                    self.showCartThumbnailView()
                }
            } else {
                self.hideCartThumbnailView()
            }
        }
    }

    func showCartThumbnailView() {
        cartThumbnailView.isHidden = false
        self.cartThumbnailView.snp.updateConstraints { (make) in
            make.height.equalTo(50)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        })
        updateExistingViewInsets(cartThumbnailHeight: 50)
    }

    func hideCartThumbnailView() {
        cartThumbnailView.isHidden = true
        self.cartThumbnailView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.view.layoutIfNeeded()
        updateExistingViewInsets(cartThumbnailHeight: 0)
    }

    @objc
    func cartTapped() {
        self.tabBarDelegate?.showOrderCart()
    }

    private func updateExistingViewInsets(cartThumbnailHeight: CGFloat) {
        for vc in self.children {
            guard let navVC = vc as? DoorDashNavigationController,
                let mainVC = navVC.viewControllers.first else {
                    continue
            }
            for subview in mainVC.view.subviews {
                guard let subview = subview as? UICollectionView else {
                    continue
                }
                let newEdge = UIEdgeInsets(
                    top: subview.contentInset.top,
                    left: subview.contentInset.left,
                    bottom: subview.contentInset.bottom + cartThumbnailHeight,
                    right: subview.contentInset.right
                )
                subview.contentInset = newEdge
                subview.scrollIndicatorInsets = newEdge
            }
        }
    }
}

extension MainTabBarController {

    private func setupUI() {
        setupTabbar()
        setupCartThumbnailView()
        setupConstraints()
    }

    private func setupTabbar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        self.hidesBottomBarWhenPushed = false
    }

    private func setupCartThumbnailView() {
        self.view.addSubview(cartThumbnailView)
        cartThumbnailView.setupText(description: "Squat & Gobble (1 item)")
        let tap = UITapGestureRecognizer(target: self, action: #selector(cartTapped))
        cartThumbnailView.addGestureRecognizer(tap)
        cartThumbnailView.isHidden = true
    }

    private func setupConstraints() {
        cartThumbnailView.snp.makeConstraints({ (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
            make.height.equalTo(0)
        })
    }
}
