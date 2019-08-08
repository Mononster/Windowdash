//
//  PaymentMethodsViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import Stripe
import IGListKit

protocol PaymentMethodsViewControllerDelegate: class {
    func dismiss()
    func showAddCardModule()
}

final class PaymentMethodsViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private let navigationBar: CustomNavigationBar
    private let collectionView: UICollectionView
    private let viewModel: PaymentMethodsViewModel
    let style: BaseViewControllerStyle
    private let hideApplePayTitle: Bool

    weak var delegate: PaymentMethodsViewControllerDelegate?

    init(style: BaseViewControllerStyle, hideApplePayTitle: Bool = false) {
        self.style = style
        self.hideApplePayTitle = hideApplePayTitle
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        navigationBar = CustomNavigationBar.create()
        viewModel = PaymentMethodsViewModel(
            userService: UserAPIService(),
            paymentService: PaymentAPIService(),
            dataStore: ApplicationEnvironment.current.dataStore
        )
        super.init()
        adapter.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModels()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    private func bindModels() {
        self.loadingIndicator.show()
        viewModel.registerStripeCredential { [weak self] in
            guard let `self` = self else {
                return
            }
            self.viewModel.fetchPaymentMethods(completion: { errorMsg in
                self.loadingIndicator.hide()
                if let errorMsg = errorMsg {
                    self.presentErrorAlertView(title: "Something went wrong", message: errorMsg)
                    return
                }
                self.adapter.performUpdates(animated: true)
            })
        }
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func dismissButtonTapped() {
        self.delegate?.dismiss()
    }

    @objc
    private func addCardButtonTapped() {
        self.delegate?.showAddCardModule()
    }
}

extension PaymentMethodsViewController {

    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavigationBar() {
        style == .withCustomNavBar ? setupCustomNavBar() : setupNativeNavBar()
    }

    private func setupNativeNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let rightBarButton = UIBarButtonItem(title: "Add a card", style: .plain, target: self, action: #selector(addCardButtonTapped))
        rightBarButton.setTitleTextAttributes([NSAttributedString.Key.font: theme.fonts.medium18], for: .normal)
        self.navigationItem.setRightBarButtonItems([rightBarButton], animated: false)
        self.navigationItem.title = "Payment"
        let backBarButton = UIBarButtonItem(title: "Payment", style: .plain, target: nil, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: theme.fonts.medium18], for: .normal)
        self.navigationItem.backBarButtonItem = backBarButton
    }

    private func setupCustomNavBar() {
        self.view.addSubview(navigationBar)
        self.navigationBar.title = "Payment"
        navigationBar.bottomLine.isHidden = true
        navigationBar.setLeftButton(normal: theme.imageAssets.backTriangleIcon,
                                    highlighted: theme.imageAssets.backTriangleIcon,
                                    title: "Back",
                                    titleColor: theme.colors.doorDashRed)
        navigationBar.onClickLeftButton = {
            self.dismissButtonTapped()
        }

        navigationBar.setRightButton(title: "Add a card",
                                     titleColor: theme.colors.doorDashRed)
        navigationBar.onClickRightButton = {
            self.addCardButtonTapped()
        }
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            if self.style == .withCustomNavBar {
                make.top.equalTo(navigationBar.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
        }
    }
}

extension PaymentMethodsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = PaymentMethodSectionController(hideHeader: hideApplePayTitle)
        controller.userTappedCell = { [weak self] id in
            guard let `self` = self else {
                return
            }
            self.loadingIndicator.show()
            self.viewModel.updateUserDefaultCard(id: id) {
                self.loadingIndicator.hide()
                self.delegate?.dismiss()
            }
        }
        return controller
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

