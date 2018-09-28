//
//  CuisineAllStoresViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-27.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class CuisineAllStoresViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let collectionView: UICollectionView
    private let nvLoadingIndicator: NVActivityIndicatorView
    private let navigationBar: CustomNavigationBar
    
    private let viewModel: CuisineAllStoresViewModel

    init(cuisine: BrowseFoodCuisineCategory) {
        let width = UIScreen.main.bounds.width / 2
        navigationBar = CustomNavigationBar(
            frame: CGRect(x: 0, y: 0,
                          width: width,
                          height: ApplicationDependency.manager.theme.navigationBarHeight
            )
        )
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let loadingSize: CGFloat = 40
        let loadingViewFrame = CGRect(
            x: width - loadingSize / 2, y: 150,
            width: loadingSize, height: loadingSize
        )
        nvLoadingIndicator = NVActivityIndicatorView(
            frame: loadingViewFrame,
            type: .circleStrokeSpin,
            color: ApplicationDependency.manager.theme.colors.doorDashRed
        )
        viewModel = CuisineAllStoresViewModel(service: BrowseFoodAPIService(),
                                              cuisine: cuisine)
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.hidesBottomBarWhenPushed = false
    }

    private func bindModels() {
        nvLoadingIndicator.isHidden = false
        nvLoadingIndicator.startAnimating()
        viewModel.fetchStores { errorMsg in
            self.nvLoadingIndicator.stopAnimating()
            self.nvLoadingIndicator.isHidden = true
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            DispatchQueue.main.async {
                self.adapter.performUpdates(animated: false)
            }
        }
    }
}

extension CuisineAllStoresViewController {

    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
        setupLoadingIndicator()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.title = viewModel.cuisineName
    }

    private func setupLoadingIndicator() {
        self.view.addSubview(nvLoadingIndicator)
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        if let interactivePopGestureRecognizer = navigationController?.interactivePopGestureRecognizer {
            collectionView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
        }
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
}

extension CuisineAllStoresViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is BrowseFoodAllStoreItem:
            guard let item = object as? BrowseFoodAllStoreItem else {
                fatalError()
            }
            let controller = BrowseFoodAllStoresSectionController(addInset: item.shouldAddTopInset)
            controller.edgeSwipeBackGesture = self.navigationController?.interactivePopGestureRecognizer
            return controller
        default:
            return BrowseFoodAllStoresSectionController(addInset: true)
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CuisineAllStoresViewController: UIScrollViewDelegate {

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

