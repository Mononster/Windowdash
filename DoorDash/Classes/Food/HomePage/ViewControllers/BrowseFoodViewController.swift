//
//  BrowseFoodViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import SkeletonView
import IGListKit

protocol BrowseFoodViewControllerDelegate: class {
    func showCuisineAllStores(cuisine: BrowseFoodCuisineCategory)
    func showCuratedCategoryAllStores(id: String, name: String, description: String?)
    func showDetailStorePage(id: String)
}

final class BrowseFoodViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let skeletonLoadingView: SkeletonLoadingView
    private let navigationBar: DynamicHeightNavigationBar
    private let navigationBarHeight: CGFloat
    private let navigattionBarMinHeight: CGFloat
    private let collectionView: UICollectionView
    private var previousOffset: CGFloat = 0
    private let viewModel: BrowseFoodViewModel

    weak var delegate: BrowseFoodViewControllerDelegate?

    override init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        navigationBarHeight = UIScreen.main.bounds.height / 4.4
        navigattionBarMinHeight = ApplicationDependency.manager.theme.navigationBarHeight
        navigationBar = DynamicHeightNavigationBar(
            frame: CGRect(x: 0, y: 0,
                          width: UIScreen.main.bounds.width, height: navigationBarHeight)
        )
        viewModel = BrowseFoodViewModel(service: BrowseFoodAPIService())
        skeletonLoadingView = SkeletonLoadingView()
        super.init()
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModels()

//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            ApplicationDependency.manager.coordinator
//                .getMainTabbarController()?.showCartThumbnailView()
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        skeletonLoadingView.show()
    }

    private func bindModels() {
        self.navigationBar.addressView.addressContentLabel.text = viewModel.generateUserAddressContent()
        viewModel.fetchMainViewLayout { errorMsg in
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }

            DispatchQueue.main.async {
                self.skeletonLoadingView.hide()
                self.adapter.performUpdates(animated: false)
            }
        }
    }
}

extension BrowseFoodViewController {

    private func setupUI() {
        setupCollectionView()
        setupSkeletonLoadingView()
        setupNavigationBar()
        setupConstraints()
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
        let inset = UIEdgeInsets(
            top: navigationBarHeight - UIDevice.current.statusBarHeight, left: 0,
            bottom: 0, right: 0
        )
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
    }

    private func setupSkeletonLoadingView() {
        self.view.addSubview(skeletonLoadingView)
    }

    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }

        skeletonLoadingView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension BrowseFoodViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topInset = navigationBarHeight
        let offsetY = scrollView.contentOffset.y + topInset
        navigationBar.adjustBySrollView(offsetY: offsetY,
                                        previousOffset: previousOffset,
                                        navigattionBarMinHeight: navigattionBarMinHeight)
        previousOffset = offsetY
    }
}

extension BrowseFoodViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is CuisinePages:
            let controller = CuisineCarouselSectionController()
            controller.didSelectCuisine = { cuisine in
                self.delegate?.showCuisineAllStores(cuisine: cuisine)
            }
            return controller
        case is StoreCarouselItems:
            let controller = StoreCarouselSectionController()
            controller.seeAllButtonTapped = { id, name, description in
                self.delegate?.showCuratedCategoryAllStores(id: id, name: name, description: description)
            }
            controller.didSelectItem = { storeID in
                self.delegate?.showDetailStorePage(id: storeID)
            }
            return controller
        case is BrowseFoodAllStoreItem:
            guard let item = object as? BrowseFoodAllStoreItem else {
                fatalError()
            }
            let controller = BrowseFoodAllStoresSectionController(
                addInset: item.shouldAddTopInset, menuLayout: .centerOneItem
            )
            controller.didSelectItem = { storeID in
                self.delegate?.showDetailStorePage(id: storeID)
            }
            return controller
        case is BrowseFoodAllStoreHeaderModel:
            return BrowseFoodAllStoreHeaderSectionController()
        default:
            fatalError()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension BrowseFoodViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if distance < 100 {
            self.viewModel.loadMoreStores { shouldRefresh in
                DispatchQueue.main.async {
                    if shouldRefresh {
                        self.adapter.performUpdates(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
