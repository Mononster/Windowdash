//
//  BrowseFoodViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

class BrowseFoodViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    let navigationBar: DynamicHeightNavigationBar
    let navigationBarHeight: CGFloat
    let navigattionBarMinHeight: CGFloat
    let collectionView: UICollectionView
    var previousOffset: CGFloat = 0

    override init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        navigationBarHeight = UIScreen.main.bounds.height / 4.4
        navigattionBarMinHeight = ApplicationDependency.manager.theme.navigationBarHeight
        navigationBar = DynamicHeightNavigationBar(
            frame: CGRect(x: 0, y: 0,
                          width: UIScreen.main.bounds.width, height: navigationBarHeight)
        )
        super.init()
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension BrowseFoodViewController {

    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
    }

    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension BrowseFoodViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        navigationBar.adjustBySrollView(offsetY: offsetY,
                                        previousOffset: previousOffset,
                                        navigattionBarMinHeight: navigattionBarMinHeight)
        previousOffset = offsetY
    }
}

extension BrowseFoodViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var result: [ListDiffable] = []
        for i in 0..<20 {
            result.append(SubletTitleCellModel(title: "Nice\(i)"))
        }
        return result
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return BrowseFoodSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
