//
//  OrderCartViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

protocol OrderCartViewControllerDelegate: class {
    func presentStorePage(storeID: String)
    func presentCheckoutPage()
    func presentItemDetailPage(itemID: String, storeID: String, selectedData: ItemSelectedData?)
    func dismiss()
}

final class OrderCartViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private let viewModel: OrderCartViewModel
    private let collectionView: UICollectionView
    private let continueButton: OrderTwoTitlesButton
    private let gradientButtonView: GradientButtonView

    weak var delegate: OrderCartViewControllerDelegate?

    override init() {
        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        gradientButtonView = GradientButtonView()
        continueButton = OrderTwoTitlesButton()
        viewModel = OrderCartViewModel()
        super.init()
        adapter.dataSource = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("OrderCartViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    private func loadData(showLoadingIndicator: Bool = true) {
        setupUIInteractionState(enable: false)
        if showLoadingIndicator {
            pageLoadingIndicator.show()
        }
        viewModel.fetchCurrentCart { (errorMsg) in
            self.pageLoadingIndicator.hide()
            self.setupUIInteractionState(enable: true)
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            self.navigationItem.title = self.viewModel.cartViewModel?.storeDisplayName
            self.adapter.performUpdates(animated: true)
            self.gradientButtonView.isHidden = false
            self.continueButton.isHidden = false
            self.updateContinueButtonText()
            ApplicationDependency.manager.informMainTabbarVCUpdateCart()
        }
    }

    private func setupActions() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(continueButtonTapped))
        continueButton.addGestureRecognizer(tap)
    }

    private func removeItem(id: Int64) {
        setupUIInteractionState(enable: false)
        self.pageLoadingIndicator.show()
        self.viewModel.removeItem(id: id, completion: { (errorMsg) in
            self.setupUIInteractionState(enable: true)
            if let error = errorMsg {
                self.pageLoadingIndicator.hide()
                log.error(error)
                self.presentErrorAlertView(title: "Whoops", message: error)
                return
            }
            self.loadData(showLoadingIndicator: false)
        })
    }
}

extension OrderCartViewController {
    @objc
    private func willEnterForeground() {
        loadData()
    }

    @objc
    private func continueButtonTapped() {
        self.delegate?.presentCheckoutPage()
    }

    @objc
    private func dismissButtonTapped() {
        self.delegate?.dismiss()
    }
}

extension OrderCartViewController {

    private func setupUI() {
        self.view.backgroundColor = theme.colors.white
        setupNavigationBar()
        setupCollectionView()
        setupGradientButtonView()
        setupContinueButton()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let leftBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissButtonTapped))
        leftBarButton.setTitleTextAttributes([NSAttributedString.Key.font: theme.fontSchema.medium18], for: .normal)
        self.navigationItem.setLeftBarButtonItems([leftBarButton], animated: false)
        let backBarButton = UIBarButtonItem(title: "My Cart", style: .plain, target: nil, action: nil)
        backBarButton.setTitleTextAttributes([NSAttributedString.Key.font: theme.fontSchema.medium18], for: .normal)
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

    private func setupContinueButton() {
        self.continueButton.isHidden = true
        self.view.addSubview(continueButton)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        gradientButtonView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(GradientButtonView.height)
        }

        continueButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(gradientButtonView).offset(-45)
            make.height.equalTo(48)
        }
    }

    private func updateContinueButtonText() {
        self.continueButton.setupTexts(
            title: "Continue",
            price: viewModel.cartViewModel?.totalBeforeTaxDisplay ?? ""
        )
    }

    private func setupUIInteractionState(enable: Bool) {
        self.collectionView.isUserInteractionEnabled = enable
        self.continueButton.isUserInteractionEnabled = enable
    }
}

extension OrderCartViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is OrderCartItemPresentingModel:
            let controller = OrderCartItemSectionController()
            controller.userRemovedItem = { [weak self] id in
                self?.removeItem(id: id)
            }
            controller.userTappedItem = { [weak self] id in
                guard let storeID = self?.viewModel.cartViewModel?.storeID else {
                    log.error("WTF, no store id?")
                    return
                }
                self?.delegate?.presentItemDetailPage(
                    itemID: String(id),
                    storeID: storeID,
                    selectedData: self?.viewModel.generateItemSelectedData(itemID: id)
                )
            }
            return controller
        case is OrderCartAddMoreItemsPresentingModel:
            let controller = OrderCartAddMoreItemsSectionController()
            controller.addMoreItemTapped = { [weak self] in
                guard let id = self?.viewModel.cartViewModel?.storeID else {
                    log.error("WTF, no store id?")
                    return
                }
                self?.delegate?.presentStorePage(storeID: id)
            }
            return controller
        case is OrderCartPromoCodePresentingModel:
            return OrderCartPromoCodeSectionController()
        case is OrderCartPriceDisplayPresentingModel:
            return OrderCartPriceDisplaySectionController()
        default:
            return OrderCartItemSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
