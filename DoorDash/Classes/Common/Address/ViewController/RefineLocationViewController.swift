//
//  RefineLocationViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class RefineLocationViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let collectionView: UICollectionView
    private let viewModel: ConfirmAddressViewModel
    private let confirmButton: UIButton
    private let separator: Separator
    private let sectionController: RefineAddressSectionController

    var didSaveAddress: (() -> ())?

    init(viewModel: ConfirmAddressViewModel) {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        separator = Separator.create()
        confirmButton = UIButton()
        self.viewModel = viewModel
        self.sectionController = RefineAddressSectionController()
        super.init()
        adapter.dataSource = self
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension RefineLocationViewController {

    private func setupUI() {
        self.navigationItem.title = "Refine Address"
        self.navigationItem.backBarButtonItem?.tintColor = theme.colors.doorDashRed
        self.view.backgroundColor = theme.colors.backgroundGray
        setupCollectionView()
        setupConfirmButton()
        setupConstraints()
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.backgroundGray
        collectionView.alwaysBounceVertical = false
    }

    private func setupConfirmButton() {
        self.view.addSubview(separator)
        self.view.addSubview(confirmButton)
        confirmButton.setTitle("Save Address", for: .normal)
        confirmButton.setTitleColor(theme.colors.white, for: .normal)
        confirmButton.titleLabel?.font = theme.fontSchema.medium18
        confirmButton.backgroundColor = theme.colors.doorDashRed
        confirmButton.layer.cornerRadius = 4
        confirmButton.addTarget(self, action: #selector(confirmAddressButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        collectionView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-55 - bottomPadding)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom).offset(-55 - bottomPadding)
            make.height.equalTo(0.4)
        }

        confirmButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(separator.snp.bottom).offset(8)
            make.height.equalTo(45)
        }
    }
}

extension RefineLocationViewController {

    @objc
    func confirmAddressButtonTapped() {
        if let center = sectionController.getCurrentMapCenter() {
            viewModel.location.latitude = center.0
            viewModel.location.longitude = center.1
        }
        self.didSaveAddress?()
    }
}

extension RefineLocationViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [viewModel.generatePresentingModel()]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

