//
//  StoreDetailViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

protocol StoreDetailViewControllerDelegate: class {
    func dismiss()
    func showItemDetail(itemID: String, storeID: String)
}

enum StoreDetailViewControllerStyle {
    case withCustomNavBar
    case nativeNavBar
}

final class StoreDetailViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let skeletonLoadingView: SkeletonLoadingView
    private let navigationBar: CustomNavigationBar
    private let collectionView: UICollectionView
    private let viewModel: StoreDetailViewModel
    private let style: StoreDetailViewControllerStyle
    private let menuPresenter: StoreDetailMenuSectionController

    weak var delegate: StoreDetailViewControllerDelegate?

    init(storeID: String, style: StoreDetailViewControllerStyle) {
        self.style = style
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        navigationBar = CustomNavigationBar( 
            frame: CGRect(x: 0, y: 0,
                          width: UIScreen.main.bounds.width,
                          height: ApplicationDependency.manager.theme.navigationBarHeight
            )
        )
        viewModel = StoreDetailViewModel(service: SearchStoreDetailAPIService(), storeID: storeID)
        skeletonLoadingView = SkeletonLoadingView()
        menuPresenter = StoreDetailMenuSectionController()
        super.init()
        menuPresenter.delegate = self
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("StoreDetailViewController deinit")
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

    private func bindModels() {
        self.viewModel.fetchStore { [weak self] errorMsg in
            self?.skeletonLoadingView.hide()
            if let errorMsg = errorMsg {
                print(errorMsg)
                return
            }
            self?.adapter.performUpdates(animated: true)
        }
    }

    private func setupActions() {
        navigationBar.onClickLeftButton = { [weak self] in
            self?.delegate?.dismiss()
        }
    }
}

extension StoreDetailViewController {

    private func setupUI() {
        if self.style == .withCustomNavBar {
            setupNavigationBar()
        }
        setupCollectionView()
        setupSkeletonLoadingView()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(navigationBar)
        navigationBar.bottomLine.isHidden = true
        navigationBar.setLeftButton(normal: theme.imageAssets.backTriangleIcon,
                                    highlighted: theme.imageAssets.backTriangleIcon,
                                    title: "Back",
                                    titleColor: theme.colors.doorDashRed)
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
        if !ApplicationDependency.manager.isEmptyCart {
            collectionView.contentInset = UIEdgeInsets(
                top: 0, left: 0,
                bottom: ApplicationDependency.manager.cartThumbnailViewHeight, right: 0
            )
        }
    }

    private func setupSkeletonLoadingView() {
        self.view.addSubview(skeletonLoadingView)
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

        skeletonLoadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView)
        }
    }
}

extension StoreDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - viewModel.heightForOverallSection
        for menuControl in viewModel.menuControls {
            if menuControl.withinRange(pos: offset) {
                // scroll to this cell
                menuPresenter.adjustMenuNavigator(section: menuControl.sectionIndex)
                break
            }
        }
    }
}

extension StoreDetailViewController: StoreDetailMenuSectionControllerDelegate {

    func navigatorButtonTapped(index: Int) {
        let overViewOffset = viewModel.heightForOverallSection
        var menuSectionOffset: CGFloat = 0
        for menuControl in viewModel.menuControls {
            if menuControl.sectionIndex == index {
                menuSectionOffset = menuControl.sectionStartPos
            }
        }
        let offsetX = self.collectionView.contentOffset.x
        self.collectionView.setContentOffset(
            CGPoint(x: offsetX, y: overViewOffset + menuSectionOffset),
            animated: true
        )

        // Hacky way of not triggering scroll view did scroll
        // might consider some better ways in the future.
        adapter.scrollViewDelegate = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.adapter.scrollViewDelegate = self
        }
    }

    func itemTapped(id: String) {
        self.delegate?.showItemDetail(itemID: id, storeID: viewModel.storeID)
    }
}

extension StoreDetailViewController: StoreDetailSwitchMenuSectionControllerDelegate {
    
    func userTappedSwitchMenu() {
        let alert = UIAlertController(
            title: viewModel.getStoreDisplayName(), message: nil,
            preferredStyle: .actionSheet
        )
        let menuTitles = viewModel.generateSwitchMenuTitles()
        for key in menuTitles.keys {
            alert.addAction(UIAlertAction(title: key, style: .destructive, handler: { action in
                if let index = menuTitles[action.title ?? ""] {
                    self.viewModel.switchMenuWith(index: index)
                    self.adapter.performUpdates(animated: false)
                }
            }))
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(theme.colors.doorDashRed, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension StoreDetailViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is StoreDetailOverviewPresentingModel:
            return StoreDetailOverviewSectionController()
        case is StoreDetailSwitchMenuPresentingModel:
            let controller = StoreDetailSwitchMenuSectionController()
            controller.delegate = self
            return controller
        case is StoreDetailMenuPresentingModel:
            return menuPresenter
        default:
            return BrowseFoodAllStoreHeaderSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

