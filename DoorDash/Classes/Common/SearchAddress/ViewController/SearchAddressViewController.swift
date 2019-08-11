//
//  SearchAddressViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import IGListKit

protocol SearchAddressViewControllerDelegate: class {
    func dismiss()
    func didChangedAddress()
}

final class SearchAddressViewController: BaseListViewController {

    private let interactor: SearchAddressInteractor
    private let searchSectionController: SearchAddressInputSectionController
    private let addressLoadingIndicator: NVActivityIndicatorView

    weak var delegate: SearchAddressViewControllerDelegate?

    init(interactor: SearchAddressInteractor) {
        self.interactor = interactor
        self.searchSectionController = SearchAddressInputSectionController()
        self.addressLoadingIndicator = NVActivityIndicatorView(frame: CGRect.zero, lineWidth: 3)
        super.init()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.collectionViewDelegate = self
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        addKeyboardNotifications()
    }

    private func loadData() {
        interactor.loadData()
    }

    override func adjustViewWhenKeyboardShow(notification: NSNotification) {
        guard let keyboard = obtainKeyboardInfo(from: notification) else { return }
        collectionView.contentInset = .init(top: 0, left: 0, bottom: keyboard.keyboardHeight, right: 0)
    }

    override func adjustViewWhenKeyboardDismiss(notification: NSNotification) {
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension SearchAddressViewController {

    private func setupUI() {
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Enter Address"
        let leftBarButton = UIBarButtonItem(image: theme.imageAssets.dismissIcon, style: .plain, target: self, action: #selector(dismissButtonTapped))
        navigationItem.setLeftBarButtonItems([leftBarButton], animated: false)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = theme.colors.backgroundGray
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SearchAddressViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is SearchAddressInputPresentingModel:
            return searchSectionController
        case is SearchAddressItemPresentingModel:
            let controller = SearchAddressItemSectionController()
            controller.didSelectAddress = { address in
                self.view.endEditing(true)
                self.interactor.handleSelectedAddress(model: address)
                self.searchSectionController.updateInputText(address.placeName)
            }
            return controller
        case is SearchAddressItemsPresentingModel:
            return SearchAddressItemsSectionController()
        case is EnterAddressInputPresentingModel:
            return EnterAddressInputSectionController()
        case is EnterAddressMapPresentingModel:
            return EnterAddressMapSectionController()
        case is SearchAddressEmptyResultPresentingModel:
            return SearchAddressEmptyResultSectionController()
        case is ConfirmActionPresentingModel:
            return ConfirmActionSectionController()
        default:
            fatalError()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension SearchAddressViewController: SearchAddressPresenterOutput {

    func showPresentationData(models: [ListDiffable]) {
        sectionData = models
        adapter.performUpdates(animated: true)
    }

    func showInitLoadingState() {
        view.addSubview(addressLoadingIndicator)
        addressLoadingIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
            make.top.equalToSuperview().offset(SearchAddressInputCell.Constants().height + 32)
        }
        view.bringSubviewToFront(addressLoadingIndicator)
        addressLoadingIndicator.startAnimating()
    }

    func hideLoadingState() {
        addressLoadingIndicator.stopAnimating()
        addressLoadingIndicator.removeFromSuperview()
    }

    func showChangedAddress() {
        delegate?.didChangedAddress()
    }

    func dimissModule() {
        delegate?.dismiss()
    }
}

extension SearchAddressViewController {

    @objc
    private func dismissButtonTapped() {
        view.endEditing(true)
        delegate?.dismiss()
    }
}
