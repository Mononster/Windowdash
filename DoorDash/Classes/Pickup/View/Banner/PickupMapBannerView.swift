//
//  PickupMapBannerView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class PickupMapBannerView: UIView {

    enum ViewPresentingState {
        case hidden
        case presenting
        case dismissing
        case present
    }

    struct Constants {
    }

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    }()

    private let collectionView: UICollectionView
    private var sectionData: [ListDiffable] = []
    private var currentViewModel: StoreViewModel?
    private let theme = ApplicationDependency.manager.theme

    var viewState: ViewPresentingState = .hidden

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

    func configData(viewModel: StoreViewModel) {
        sectionData.removeAll()
        currentViewModel = viewModel
        sectionData.append(viewModel.convertToPresenterItem(shouldAddInset: true, mode: .pickup, layout: .centerTwoItems))
        adapter.performUpdates(animated: true)
    }

    static func calcHeight(viewModel: StoreViewModel) -> CGFloat {
        var height: CGFloat = 4
        if viewModel.menuURLs.count == 0 {
            height += BrowseFoodStoreDispalyCell.heightWithoutMenu
        } else {
            height += BrowseFoodStoreDispalyCell.heightWithMenu + BrowseFoodAllStoresSectionController.Constants().centerTwoItemsHeight
        }
        if viewModel.closeTimeDisplay != nil {
            height += BrowseFoodStoreDispalyCell.closeTimeHeight
        }
        return height
    }
}

extension PickupMapBannerView {

    private func setupUI() {
        backgroundColor = theme.colors.white
        setupCollectionView()
        setupConstraints()
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = 8
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(-8)
        }
    }
}

extension PickupMapBannerView: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is BrowseFoodAllStoreItem:
            guard let item = object as? BrowseFoodAllStoreItem else {
                fatalError()
            }
            let controller = BrowseFoodAllStoresSectionController(
                addInset: item.shouldAddTopInset,
                menuLayout: item.layout
            )
            controller.didSelectItem = { storeID in
                //self.delegate?.showDetailStorePage(id: storeID)
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
