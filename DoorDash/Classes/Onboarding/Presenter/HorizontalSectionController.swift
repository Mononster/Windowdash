//
//  HorizontalSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class HorizontalSectionController: ListSectionController, ListAdapterDataSource {

    private var items: OnboardingItems?
    private var currentCell: HorizontalScrollCollectionViewCell?

    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        return adapter
    }()

    private var pageControlCurrentIndex: Int {
        guard let collectionView = currentCell?.collectionView else {
            return 0
        }
        let width = collectionContext!.containerSize.width
        var currentIndex = Int((collectionView.contentOffset.x + width * 0.5) / width)
        currentIndex = max(0, currentIndex)
        return currentIndex
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: collectionContext?.containerSize.height ?? 0)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: HorizontalScrollCollectionViewCell.self,
            for: self,
            at: index) as? HorizontalScrollCollectionViewCell else {
                fatalError()
        }
        adapter.collectionView = cell.collectionView
        cell.pageControl.numberOfPages = items?.items.count ?? 0
        currentCell = cell
        return cell
    }

    override func didUpdate(to object: Any) {
        items = object as? OnboardingItems
    }

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableItems: [ListDiffable] = []
        for item in items?.items ?? [] {
            diffableItems.append(item)
        }
        return diffableItems
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return OnboardingItemSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HorizontalSectionController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentCell?.pageControl.currentPage = pageControlCurrentIndex
    }
}
