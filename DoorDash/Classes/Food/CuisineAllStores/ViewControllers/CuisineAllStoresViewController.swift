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

protocol CuisineAllStoresViewControllerDelegate: class {
    func dismiss()
    func showDetailStorePage(id: String)
}

final class CuisineAllStoresViewController: BaseSearchAllStoresViewController {

    private let viewModel: CuisineAllStoresViewModel

    weak var delegate: CuisineAllStoresViewControllerDelegate?

    init(cuisine: BrowseFoodCuisineCategory) {
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
        bindModels()
        setupActions()
    }

    override func setupUI() {
        super.setupUI()
        self.navigationBar.title = viewModel.cuisineName
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

    private func setupActions() {
        navigationBar.onClickLeftButton = {
            self.delegate?.dismiss()
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
            let controller = SingleStoreSectionController(
                topInset: item.topInset,
                menuLayout: .centerOneItem
            )
            controller.didSelectItem = { storeID in
                self.delegate?.showDetailStorePage(id: storeID)
            }
            controller.edgeSwipeBackGesture = self.navigationController?.interactivePopGestureRecognizer
            return controller
        default:
            fatalError()
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

