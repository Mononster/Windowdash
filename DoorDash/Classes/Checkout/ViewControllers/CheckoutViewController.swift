//
//  CheckoutViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

protocol CheckoutViewControllerDelegate: class {
    func dismiss()
    func showPaymentPage()
}

final class CheckoutViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let viewModel: CheckoutViewModel
    private let collectionView: UICollectionView
    private let gradientButtonView: GradientButtonView
    private let checkouButton: OrderTwoTitlesButton

    weak var delegate: CheckoutViewControllerDelegate?

    override init() {
        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        gradientButtonView = GradientButtonView()
        checkouButton = OrderTwoTitlesButton()
        viewModel = CheckoutViewModel()
        super.init()
        adapter.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadData()
    }

    private func loadData(showLoadingIndicator: Bool = true) {
        setupUIInteractionState(enable: false)
        self.loadingIndicator.show()
        viewModel.fetchCurrentCart { (errorMsg) in
            self.loadingIndicator.hide()
            self.setupUIInteractionState(enable: true)
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            self.adapter.performUpdates(animated: true)
            self.gradientButtonView.isHidden = false
            self.checkouButton.isHidden = false
            self.updateContinueButtonText()
            ApplicationDependency.manager.informMainTabbarVCUpdateCart()
        }
    }

    func refreshData() {
        self.viewModel.refreshPaymentSection()
        self.adapter.performUpdates(animated: false, completion: nil)
    }

    private func setupActions() {

    }

    private func updateContinueButtonText() {
        self.checkouButton.setupTexts(
            title: "Place Order",
            price: viewModel.totalFee.toFloatString()
        )
    }

    @objc
    private func checkoutButtonTapped() {

    }
}

extension CheckoutViewController {

    private func setupUI() {
        self.view.backgroundColor = theme.colors.white
        setupNavigationBar()
        setupCollectionView()
        setupGradientButtonView()
        setupCheckoutButton()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "Checkout"
        let backBarButton = UIBarButtonItem(title: "My Cart", style: .plain, target: nil, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: theme.fonts.medium18], for: .normal)
        self.navigationItem.backBarButtonItem = backBarButton
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: GradientButtonView.height - 50, right: 0)
        collectionView.contentInset = inset
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupGradientButtonView() {
        gradientButtonView.isHidden = true
        self.view.addSubview(gradientButtonView)
    }

    private func setupCheckoutButton() {
        self.checkouButton.isHidden = true
        self.view.addSubview(checkouButton)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        gradientButtonView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(GradientButtonView.height)
        }

        checkouButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(gradientButtonView).offset(-45)
            make.height.equalTo(48)
        }
    }

    private func setupUIInteractionState(enable: Bool) {
        self.collectionView.isUserInteractionEnabled = enable
        self.checkouButton.isUserInteractionEnabled = enable
    }
}

extension CheckoutViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is CheckoutDeliveryDetailsPresentingModel:
            return CheckoutDeliveryDetailsSectionController()
        case is CheckoutPaymentPresentingModel:
            let controller = CheckoutPaymentSectionController()
            controller.delegate = self
            return controller
        default:
            return CheckoutPaymentSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CheckoutViewController: CheckoutPaymentSectionControllerDelegate {

    func showPaymentPage() {
        self.delegate?.showPaymentPage()
    }

    func userChangedTipValue(index: Int) {
        self.viewModel.updateSelectedTipValue(index: index)
        self.updateContinueButtonText()
        self.adapter.performUpdates(animated: false)
    }
}
