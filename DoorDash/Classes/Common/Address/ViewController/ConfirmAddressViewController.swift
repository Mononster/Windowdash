//
//  ConfirmAddressViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

protocol ConfirmAddressViewControllerDelegate: class {
    func userTappedRefineLocation(viewModel: ConfirmAddressViewModel)
    func userTappedConfirmButton()
}

final class ConfirmAddressViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let collectionView: UICollectionView
    private let viewModel: ConfirmAddressViewModel
    private let confirmButton: UIButton
    private let separator: Separator
    private let sectionController: ConfirmAddressSectionController

    weak var delegate: ConfirmAddressViewControllerDelegate?

    init(location: GMDetailLocation) {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        confirmButton = UIButton()
        separator = Separator.create()
        self.viewModel = ConfirmAddressViewModel(
            location: location,
            dataStore: ApplicationEnvironment.current.dataStore
        )
        sectionController = ConfirmAddressSectionController()
        super.init()
        adapter.dataSource = self
        sectionController.delegate = self
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func refreshUI() {
        self.adapter.performUpdates(animated: true)
    }
}

extension ConfirmAddressViewController {

    private func setupUI() {
        self.navigationItem.title = "Confirm Address"
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
        confirmButton.setTitle("Confirm Address", for: .normal)
        confirmButton.setTitleColor(theme.colors.white, for: .normal)
        confirmButton.titleLabel?.font = theme.fonts.medium18
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

extension ConfirmAddressViewController {

    @objc
    func confirmAddressButtonTapped() {
        self.viewModel.location.dasherInstructions = sectionController.dasherInstruction
        self.loadingIndicator.show()
        self.viewModel.postNewUserAddress { (_, error) in
            self.loadingIndicator.hide()
            if let error = error {
                log.error(error)
                return
            }
            self.delegate?.userTappedConfirmButton()
        }
    }   
}

extension ConfirmAddressViewController: ListAdapterDataSource {

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

extension ConfirmAddressViewController: ConfirmAddressSectionControllerDelegate {

    func userTappedRefineLocation() {
        self.delegate?.userTappedRefineLocation(viewModel: viewModel)
    }
}
