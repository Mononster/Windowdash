//
//  BaseSearchAllStoresViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 9/28/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

class BaseSearchAllStoresViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    let collectionView: UICollectionView
    let nvLoadingIndicator: NVActivityIndicatorView
    let navigationBar: CustomNavigationBar

    override init() {
        let width = UIScreen.main.bounds.width / 2
        navigationBar = CustomNavigationBar(
            frame: CGRect(x: 0, y: 0,
                          width: UIScreen.main.bounds.width,
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
        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    func setupUI() {
        setupNavigationBar()
        setupCollectionView()
        setupLoadingIndicator()
        setupConstraints()
    }

}

extension BaseSearchAllStoresViewController {

    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.bottomLine.isHidden = true
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

