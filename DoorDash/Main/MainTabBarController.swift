//
//  MainTabBarController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum TabbarItemType: Int {
    case delivery = 0
    case pickup
    case search
    case orders
    case account
}

typealias TabConfig = (title: String, image: UIImage, selectedImage: UIImage)

protocol MainTabBarControllerDelegate: class {
    func showOrderCart()
}

final class MainTabBarController: UITabBarController {

    struct Constants {
        let cartThumbnailViewHeight: CGFloat = 48
        let spaceBetweenCartThumbnailAndTabbar: CGFloat = 12
    }

    weak var tabBarDelegate: MainTabBarControllerDelegate?
    private let cartThumbnailView: OrderCartThumbnailView
    let viewModel: MainTabBarViewModel

    private let constants = Constants()

    init() {
        cartThumbnailView = OrderCartThumbnailView(frame: .zero)
        viewModel = MainTabBarViewModel()
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        load()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cartThumbnailView.addShadow(
            size: CGSize(width: 0, height: 1),
            radius: constants.cartThumbnailViewHeight / 2,
            shadowColor: ApplicationDependency.manager.theme.colors.darkGray,
            shadowOpacity: 0.36
        )
    }

    func load() {
        loadData()
        if let savedCart = viewModel.loadSavedCart() {
            self.cartThumbnailView.setupText(description: savedCart.title, quantity: savedCart.quantity)
            self.showCartThumbnailView(text: savedCart.title)
        }
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
                self.cartThumbnailView.setupText(description: cartVM.storeNameDisplay, quantity: cartVM.quantityDisplay)
                self.showCartThumbnailView(text: cartVM.storeNameDisplay)
            } else {
                self.hideCartThumbnailView(animated: false)
            }
        }
    }

    func showCartThumbnailView(text: String) {
        cartThumbnailView.isHidden = false
        self.cartThumbnailView.snp.updateConstraints { (make) in
            make.top.equalTo(tabBar).offset(-constants.cartThumbnailViewHeight - constants.spaceBetweenCartThumbnailAndTabbar)
            make.width.equalTo(OrderCartThumbnailView.calcWidth(containerWidth: UIScreen.main.bounds.width, title: text))
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        })
        updateExistingViewInsets(cartThumbnailHeight: constants.cartThumbnailViewHeight)
    }

    func hideCartThumbnailView(animated: Bool) {
        self.cartThumbnailView.snp.updateConstraints { (make) in
            make.top.equalTo(tabBar)
        }
        updateExistingViewInsets(cartThumbnailHeight: 0)
        if !animated {
            cartThumbnailView.isHidden = true
            view.layoutIfNeeded()
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.cartThumbnailView.isHidden = true
        })
    }

    @objc
    func cartTapped() {
        self.tabBarDelegate?.showOrderCart()
    }

    private func updateExistingViewInsets(cartThumbnailHeight: CGFloat) {
        for vc in self.children {
            guard let navVC = vc as? DoorDashNavigationController,
                let mainVC = navVC.viewControllers.first, mainVC.isViewLoaded else {
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
        view.bringSubviewToFront(tabBar)
    }

    private func setupTabbar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        self.hidesBottomBarWhenPushed = false
    }

    private func setupCartThumbnailView() {
        self.view.addSubview(cartThumbnailView)
        cartThumbnailView.setupText(description: "Squat & Gobble", quantity: "1 item")
        let tap = UITapGestureRecognizer(target: self, action: #selector(cartTapped))
        cartThumbnailView.addGestureRecognizer(tap)
        cartThumbnailView.isHidden = true
        cartThumbnailView.layer.cornerRadius = constants.cartThumbnailViewHeight / 2
    }

    private func setupConstraints() {
        cartThumbnailView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(tabBar)
            make.height.equalTo(constants.cartThumbnailViewHeight)
            make.width.equalTo(UIScreen.main.bounds.width - 2 * 16.0)
        })
    }
}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let type = TabbarItemType(rawValue: tabBarController.selectedIndex) else {
            return
        }
        guard let cartVM = self.viewModel.cartViewModel else {
            return
        }
        if type == .delivery || type == .account {
            if cartThumbnailView.isHidden {
                showCartThumbnailView(text: cartVM.storeNameDisplay)
            }
        } else {
            hideCartThumbnailView(animated: true)
        }
    }
}
