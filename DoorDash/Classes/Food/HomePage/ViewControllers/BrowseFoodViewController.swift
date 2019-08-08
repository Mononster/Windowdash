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
    private let navigationBar: BrowsePageNavigationBar
    private let navigationBarHeight: CGFloat
    private let navigattionBarMinHeight: CGFloat
    private let collectionView: UICollectionView
    private let sortSelectionView: SortOptionSelectionView
    private var previousOffset: CGFloat = 0
    private let viewModel: BrowseFoodViewModel
    private let sortSectionController: StoreSortHorizontalSectionController

    weak var delegate: BrowseFoodViewControllerDelegate?

    override init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        navigationBarHeight = ApplicationDependency.manager.theme.navigationBarHeight
        navigattionBarMinHeight = 20
        navigationBar = BrowsePageNavigationBar(
            frame: CGRect(x: 0, y: 0,
                          width: UIScreen.main.bounds.width, height: navigationBarHeight)
        )
        viewModel = BrowseFoodViewModel(service: BrowseFoodAPIService())
        sortSelectionView = SortOptionSelectionView()
        skeletonLoadingView = SkeletonLoadingView()
        sortSectionController = StoreSortHorizontalSectionController()
        super.init()
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModels()
    }

    override func viewDidAppear(_ animated: Bool) {
        if !viewModel.showedSkeleton {
            self.showSkeleton(coverAll: true)
            viewModel.showedSkeleton = true
        }
    }

    private func bindModels() {
        self.navigationBar.updateTexts(
            address: viewModel.generateUserAddressContent(),
            numShops: "Loading..."
        )
        viewModel.fetchMainViewLayout { [weak self] errorMsg in
            guard let `self` = self else {
                return
            }
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }

            DispatchQueue.main.async {
                self.navigationBar.updateTexts(
                    address: self.viewModel.generateUserAddressContent(),
                    numShops: self.viewModel.getCurrentNumStoreDisplay()
                )
                self.skeletonLoadingView.hide()
                self.adapter.performUpdates(animated: false)
            }
        }
    }

    private func loadStores() {
        self.showSkeleton(coverAll: false)
        self.viewModel.loadStores(completion: { [weak self] errorMsg in
            guard let `self` = self else {
                return
            }
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            DispatchQueue.main.async {
                self.adapter.performUpdates(animated: false, completion: { finished in
                    self.skeletonLoadingView.hide()
                })
            }
        })
    }

    private func showSkeleton(coverAll: Bool) {
        if coverAll {
            skeletonLoadingView.snp.remakeConstraints { (make) in
                make.top.equalTo(navigationBar.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
        } else {
            let cuisineCategoryHeight = AnimatedCuisineItemSectionController.heightWithoutImage +
                BrowseFoodViewModel.UIConfigure.getCuisineItemSize(collectionViewWidth: self.view.frame.width)
            let filtersHeight = StoreSortBaseCell.Constants().containerHeight
            skeletonLoadingView.snp.remakeConstraints { (make) in
                make.top.equalTo(navigationBar.snp.bottom).offset(cuisineCategoryHeight + filtersHeight)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
        self.view.layoutIfNeeded()
        self.skeletonLoadingView.show()
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

extension BrowseFoodViewController {

    private func presentSortSelectionView(item: StoreSortItemPresentingModel) {
        let viewModel = SortOptionSelectionViewModel(
            model: item,
            viewResult:
        { [weak self] filter in
            guard !filter.selectedValues.isEmpty else { return }
            item.title = filter.selectedValues.joined(separator: ", ")
            self?.sortSectionController.selectSortItem(filter, selected: true)
            self?.viewModel.updateFilter(item: filter)
            self?.loadStores()
        })
        sortSelectionView.configData(viewModel: viewModel)
        sortSelectionView.show()
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
        case is CuisinePage:
            let controller = AnimatedCuisineCarouselSectionController()
            controller.didSelectCuisine = { [weak self] cuisine in
                guard let `self` = self else { return }
                self.viewModel.updateCuisineFilter(
                    name: cuisine?.friendlyName.lowercased() ?? "",
                    selected: cuisine != nil
                )
                self.loadStores()
            }
            return controller
        case is StoreSortHorizontalPresentingModel:
            sortSectionController.openSelectionView = { [weak self] item in
                self?.presentSortSelectionView(item: item)
            }
            sortSectionController.didSelectItem = { [weak self] item in
                self?.viewModel.updateFilter(item: item)
                self?.loadStores()
            }
            return sortSectionController
        case is StoreCarouselItems:
            let controller = StoreCarouselSectionController()
            controller.seeAllButtonTapped = { [weak self] id, name, description in
                self?.delegate?.showCuratedCategoryAllStores(id: id, name: name, description: description)
            }
            controller.didSelectItem = { [weak self]  storeID in
                self?.delegate?.showDetailStorePage(id: storeID)
            }
            return controller
        case is StoreHorizontalCarouselItems:
            let controller = StoreHorizontalCarouselSectionController()
            controller.seeAllButtonTapped = { [weak self] id, name, description in
                self?.delegate?.showCuratedCategoryAllStores(id: id, name: name, description: description)
            }
            controller.didSelectItem = { [weak self] storeID in
                self?.delegate?.showDetailStorePage(id: storeID)
            }
            return controller
        case is BrowseFoodAllStoreItem:
            guard let item = object as? BrowseFoodAllStoreItem else {
                fatalError()
            }
            let controller = BrowseFoodAllStoresSectionController(
                addInset: item.shouldAddTopInset, menuLayout: item.layout
            )
            controller.didSelectItem = { [weak self] storeID in
                self?.delegate?.showDetailStorePage(id: storeID)
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
