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

class BrowseFoodViewController: BaseViewController {

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
        setupNavigationBar()
        setupCollectionView()
        setupSkeletonLoadingView()
        setupConstraints()
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

    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        skeletonLoadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView)
        }
    }
}

extension BrowseFoodViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        navigationBar.adjustBySrollView(offsetY: offsetY,
                                        previousOffset: previousOffset,
                                        navigattionBarMinHeight: navigattionBarMinHeight)
        if offsetY <= navigattionBarMinHeight && offsetY > 0 {
            collectionView.contentOffset = CGPoint(x: 0, y: -offsetY)
        }
        previousOffset = offsetY
    }
}

extension BrowseFoodViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        //return viewModel.sectionData
        var data: [ListDiffable] = []
        for i in 0..<20 {
            data.append(SubletTitleCellModel(title: "Test \(i)"))
        }
        return data
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        switch object {
//        case is CuisinePages:
//            return CuisineCarouselSectionController()
//        case is StoreCarouselItems:
//            return StoreCarouselSectionController()
//        default:
//            return CuisineCarouselSectionController()
//        }
        return BrowseFoodSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
