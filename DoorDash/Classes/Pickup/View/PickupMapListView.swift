//
//  PickupMapListView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

protocol PickupMapListViewDelegate: class {
    func showDetailStorePage(id: String)
}

final class PickupMapListView: UIView {

    struct Constants {
    }

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    }()

    private let collectionView: UICollectionView
    private var sectionData: [ListDiffable] = []
    private var currentViewModels: [StoreViewModel] = []
    private let theme = ApplicationDependency.manager.theme

    var viewState: ViewPresentingState = .hidden

    weak var delegate: PickupMapBannerViewDelegate?

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: CGRect.zero)
        adapter.collectionView = self.collectionView
        adapter.dataSource = self
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configData(viewModels: [StoreViewModel]) {
        sectionData.removeAll()
        currentViewModels = viewModels
        let presentingModels = viewModels.map { $0.convertToPresenterItem(
                topInset: SingleStoreSectionController.Constants().topInsetWithImage,
                mode: .pickup,
                layout: .centerTwoItems
            )
        }
        sectionData.append(contentsOf: presentingModels)
        adapter.performUpdates(animated: true)
    }
}

extension PickupMapListView {

    private func setupUI() {
        backgroundColor = theme.colors.white
        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension PickupMapListView: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is BrowseFoodAllStoreItem:
            guard let item = object as? BrowseFoodAllStoreItem else {
                fatalError()
            }
            let controller = SingleStoreSectionController(
                topInset: item.topInset,
                menuLayout: item.layout
            )
            controller.didSelectItem = { storeID in
                self.delegate?.showDetailStorePage(id: storeID)
            }
            return controller
        default:
            fatalError()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
