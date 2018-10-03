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

final class StoreDetailViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let skeletonLoadingView: SkeletonLoadingView
    private let navigationBar: CustomNavigationBar
    private let collectionView: UICollectionView
    private let viewModel: StoreDetailViewModel
    private let menuPresenter: StoreDetailMenuSectionController

    init(storeID: String) {
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
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModels()
    }

    override func viewDidAppear(_ animated: Bool) {
        skeletonLoadingView.show()
    }

    private func bindModels() {
        self.viewModel.fetchStore { (errorMsg) in
            self.skeletonLoadingView.hide()
            if let errorMsg = errorMsg {
                print(errorMsg)
                return
            }
            self.adapter.performUpdates(animated: true)
        }
    }
}

extension StoreDetailViewController {

    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
        setupSkeletonLoadingView()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(navigationBar)
        navigationBar.bottomLine.isHidden = true
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
    }

    private func setupSkeletonLoadingView() {
        self.view.addSubview(skeletonLoadingView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }

        skeletonLoadingView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension StoreDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - viewModel.heightForOverallSection
        for menuControl in viewModel.menuControls {
            if menuControl.withinRange(pos: offset) {
                // scroll to this cell
                print("Section Index: \(menuControl.sectionIndex) \(menuControl.debugName)")
                menuPresenter.adjustMenuNavigator(section: menuControl.sectionIndex)
                break
            }
        }
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
            return StoreDetailSwitchMenuSectionController()
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

