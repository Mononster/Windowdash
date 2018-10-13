//
//  OrderCartViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

protocol OrderCartViewControllerDelegate: class {
    func dismiss()
}

final class OrderCartViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private let viewModel: OrderCartViewModel
    private let navigationBar: CustomNavigationBar
    private let collectionView: UICollectionView

    weak var delegate: OrderCartViewControllerDelegate?

    override init() {
        navigationBar = CustomNavigationBar.create()
        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        viewModel = OrderCartViewModel()
        super.init()
        adapter.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupActions()
    }

    private func loadData() {
        pageLoadingIndicator.show()
        viewModel.fetchCurrentCart { (errorMsg) in
            self.pageLoadingIndicator.hide()
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            self.navigationBar.title = self.viewModel.cartViewModel?.storeDisplayName
            self.adapter.performUpdates(animated: true)
        }
    }

    private func setupActions() {
        navigationBar.onClickLeftButton = {
            self.delegate?.dismiss()
        }
    }
}

extension OrderCartViewController {

    private func setupUI() {
        self.view.backgroundColor = theme.colors.white
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(navigationBar)
        navigationBar.bottomLine.isHidden = true
        navigationBar.setLeftButton(title: "Back", titleColor: theme.colors.doorDashRed)
        navigationBar.setNavigationBarStyle(style: .mainTheme, animated: false)
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
    }
    
    private func setupConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.navigationBar.snp.bottom)
        }
    }
}

extension OrderCartViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is OrderCartItemPresentingModel:
            return OrderCartItemSectionController()
        default:
            return OrderCartItemSectionController()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
