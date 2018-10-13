//
//  ItemDetailInfoViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

protocol ItemDetailInfoViewControllerDelegate: class {
    func dismiss()
}

final class ItemDetailInfoViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private let viewModel: ItemDetailInfoViewModel
    private let skeletonLoadingView: SkeletonLoadingView
    private let navigationBar: CustomNavigationBar
    private let collectionView: UICollectionView
    private let menuImageDisplayView: InfiniteScrollView
    private let bottomViewContainer: UIView
    private let addToOrderButton: ItemDetailAddToOrderButton
    private let gradientView: GradientView

    private let menuImageDisplayViewHeight = 1 / 3 * UIScreen.main.bounds.height
    private var navBarStyleChangeThreshold: CGFloat = 0
    private var statusBarStyle: UIStatusBarStyle = .default

    weak var delegate: ItemDetailInfoViewControllerDelegate?

    init(itemID: String, storeID: String, mode: ItemDetailEntranceMode) {
        viewModel = ItemDetailInfoViewModel(
            service: SearchStoreItemAPIService(),
            itemID: itemID,
            storeID: storeID,
            mode: mode
        )
        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        menuImageDisplayView = InfiniteScrollView(
            frame: CGRect(x: 0,
                          y: -menuImageDisplayViewHeight,
                          width: UIScreen.main.bounds.width,
                          height: menuImageDisplayViewHeight))
        navigationBar = CustomNavigationBar.create()
        skeletonLoadingView = SkeletonLoadingView()
        addToOrderButton = ItemDetailAddToOrderButton()
        gradientView = GradientView()
        bottomViewContainer = UIView()
        super.init()
        navBarStyleChangeThreshold = -theme.navigationBarHeight
        adapter.scrollViewDelegate = self
        adapter.dataSource = self
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModels()
        setupActions()
    }

    override func viewDidAppear(_ animated: Bool) {
        skeletonLoadingView.show()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    private func bindModels() {
        self.viewModel.fetchItem { (errorMsg) in
            self.skeletonLoadingView.hide()
            if let errorMsg = errorMsg {
                print(errorMsg)
                return
            }
            self.collectionView.alpha = 0
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.collectionView.alpha = 1
            })
            if let photoList = self.viewModel.headerImageList {
                self.menuImageDisplayView.setPhotos(photoList: photoList)
                self.collectionView.addSubview(self.menuImageDisplayView)
                self.menuImageDisplayView.isHidden = false
                self.collectionView.contentInset = UIEdgeInsets(
                    top: self.menuImageDisplayViewHeight, left: 0, bottom: 0, right: 0
                )
            } else {
                self.collectionView.snp.remakeConstraints { (make) in
                    make.leading.trailing.bottom.equalToSuperview()
                    make.top.equalTo(self.navigationBar.snp.bottom)
                }
                self.view.layoutIfNeeded()
            }
            self.updateAddToOrderButtonText()
            self.adapter.performUpdates(animated: true)

        }
    }

    private func setupActions() {
        navigationBar.onClickLeftButton = {
            self.delegate?.dismiss()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(addToOrderButtonTapped))
        addToOrderButton.addGestureRecognizer(tap)
    }

    private func updateAddToOrderButtonText() {
        self.addToOrderButton.setupTexts(
            title: viewModel.addToOrderButtonDisplayTitle,
            price: viewModel.currentTotal.toFloatString()
        )
    }

    @objc
    func addToOrderButtonTapped() {
        if let invalidSection = viewModel.validateAllExtras() {
            self.scroll(toIndexPathPreservingTopInset: IndexPath(row: 0, section: invalidSection + 1), animated: true)
            return
        }
        // not empty cart and new store compared to previous cart.
        if !ApplicationDependency.manager.isEmptyCart
            && Int64(viewModel.storeID)
            != ApplicationDependency.manager.cartManager.currentStoreID {
            showSwitchStoreAlert()
            return
        }
        addToOrder()
    }

    func addToOrder() {
        PaymentActivityHUD.shared.show(initialMessage: "Adding...", viewToAdd: self.view)
        viewModel.addItemToCart { (errorMsg) in
            if let errorMsg = errorMsg {
                PaymentActivityHUD.shared.hide()
                self.showNetworkErrorAlert(errorMsg: errorMsg)
                return
            }
            ApplicationDependency.manager.informMainTabbarVCUpdateCart()
            PaymentActivityHUD.shared.showSuccess(message: "Added!", completion: {
                self.delegate?.dismiss()
            })
        }
    }

    func showSwitchStoreAlert() {
        let alert = UIAlertController(title: "Start new Order?", message: "You currently have an item from another menu in your Order Cart. Would you like to clear your existing Order Cart and start a new one?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.addToOrder()
        }))
        alert.view.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        self.present(alert, animated: true, completion: nil)
    }

    func showNetworkErrorAlert(errorMsg: String) {
        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ItemDetailInfoViewController {

    private func setupUI() {
        self.collectionView.contentInsetAdjustmentBehavior = .never
        setupNavigationBar()
        setupMenuDisplayView()
        setupCollectionView()
        setupAddToOrderButton()
        setupSkeletonLoadingView()
        setupGradientView()
        setupConstraints()
        self.view.insertSubview(navigationBar, aboveSubview: collectionView)
        self.view.insertSubview(bottomViewContainer, aboveSubview: collectionView)
        self.view.insertSubview(gradientView, aboveSubview: collectionView)
    }

    private func setupGradientView() {
        self.view.addSubview(gradientView)
        self.gradientView.gradientBackgroundColor = theme.colors.white
    }

    private func setupNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(navigationBar)
        navigationBar.bottomLine.isHidden = true
        navigationBar.setLeftButton(normal: theme.imageAssets.backRoundIcon,
                                    highlighted: theme.imageAssets.backRoundIcon)
        navigationBar.setNavigationBarStyle(style: .transparent, animated: false)
    }

    private func setupMenuDisplayView() {
        self.menuImageDisplayView.isHidden = true
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
    }

    private func setupAddToOrderButton() {
        self.view.addSubview(bottomViewContainer)
        bottomViewContainer.backgroundColor = theme.colors.white

        bottomViewContainer.addSubview(addToOrderButton)
    }

    private func setupSkeletonLoadingView() {
        self.view.addSubview(skeletonLoadingView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        addToOrderButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(
                ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue
            )
            make.bottom.equalToSuperview().offset(-self.view.safeAreaInsets.bottom - 45)
            make.height.equalTo(48)
        }

        bottomViewContainer.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48 + self.view.safeAreaInsets.bottom + 45)
        }

        gradientView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomViewContainer.snp.top)
            make.height.equalTo(70)
        }

        skeletonLoadingView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ItemDetailInfoViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is ItemDetailOverviewPresentingModel:
            return ItemDetailOverviewSectionController()
        case is ItemDetailMultipleChoicePresentingModel:
            let controller = ItemDetailMultipleChoiceSectionController()
            controller.updateBlance = { cents in
                self.viewModel.updateCurrentBalance(cents: cents)
                self.updateAddToOrderButtonText()
            }
            return controller
        case is ItemDetailAddInstructionPresentingModel:
            return ItemDetailAddInstructionSectionController()
        case is ItemDetailSelectQuantityPresentingModel:
            let controller = ItemDetailSelectQuantitySectionController()
            controller.updateQuantity = { newQuantity in
                self.viewModel.updateQuantityAndBalance(newQuantity: newQuantity)
                self.updateAddToOrderButtonText()
            }
            return controller
        default:
            return ItemDetailOverviewSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension ItemDetailInfoViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > navBarStyleChangeThreshold {
            navigationBar.setNavigationBarStyle(style: .white, animated: true)
            statusBarStyle = .default
        } else {
            navigationBar.setNavigationBarStyle(style: .transparent, animated: true)
            statusBarStyle = .lightContent
        }
        setNeedsStatusBarAppearanceUpdate()

        if offsetY < -menuImageDisplayViewHeight {
            menuImageDisplayView.frame = CGRect(x: 0, y: offsetY, width: self.view.frame.width, height: -offsetY)
        }

        if offsetY < 0 {
            menuImageDisplayView.setupCurrentImageCellOffset(cellOffsetFactor: -offsetY / menuImageDisplayViewHeight)
        }
    }

    func scroll(toIndexPathPreservingTopInset indexPath: IndexPath, animated: Bool) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let attri = layout.layoutAttributesForItem(at: indexPath) else {
            return
        }
        let attriHeader = layout.layoutAttributesForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        let sectionTopInset = layout.sectionInset.top
        let navBarAdjustment = self.viewModel.headerImageList == nil ? 0 : navigationBar.frame.height
        collectionView.setContentOffset(
            CGPoint(x: 0,
                    y: attri.frame.origin.y
                       - sectionTopInset
                       - navBarAdjustment
                       - (attriHeader?.frame.height ?? 0)),
            animated: animated)
    }
}

