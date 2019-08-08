//
//  SelectAddressViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

enum EnterAddressState {
    case disable
    case enable
    case hide
}

private let selectAddressHeader = "Let us know where to send your order. Please enter an address or city name."

final class SelectAddressViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let collectionView: UICollectionView
    private let headerView: HeaderTextLabelView
    private let inputApartmentView: InputApartmentView
    private let saveAddressButon: UIButton
    private let rightNavBarButton: UIBarButtonItem
    private let viewModel: SelectAddressViewModel

    var didSelectAddress: ((GMDetailLocation) -> ())?

    private var contentSize: CGFloat {
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    override init() {
        viewModel = SelectAddressViewModel()
        headerView = HeaderTextLabelView(text: selectAddressHeader)
        rightNavBarButton = UIBarButtonItem(title: "Next", style: .done, target: nil, action: #selector(rightNavBarButtonTapped))
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        inputApartmentView = InputApartmentView()
        saveAddressButon = UIButton()
        super.init()
        adapter.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        collectionView.snp.remakeConstraints { (make) in
            make.leading.trailing.equalTo(headerView)
            make.height.equalTo(contentSize)
            make.top.equalTo(headerView.snp.bottom)
        }
        self.view.layoutIfNeeded()
        collectionView.setBorder(.all, color: theme.colors.separatorGray, borderWidth: 0.5)
    }
}

extension SelectAddressViewController {

    private func setupUI() {
        self.view.backgroundColor = theme.colors.backgroundGray
        self.navigationItem.title = "Enter Address"
        self.setCurrentStyle(style: .disable)
        setupHeaderView()
        setupCollectionView()
        setupInputApartmentView()
        setupSaveAddressButton()
        setupConstraints()
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = false
    }

    private func setupHeaderView() {
        self.view.addSubview(headerView)
    }

    private func setupInputApartmentView() {
        inputApartmentView.isHidden = true
        self.view.addSubview(inputApartmentView)
        inputApartmentView.setBorder(.all, color: theme.colors.separatorGray, borderWidth: 0.5)
    }

    private func setupSaveAddressButton() {
        self.view.addSubview(saveAddressButon)
        saveAddressButon.isHidden = true
        saveAddressButon.setTitle("Save Address", for: .normal)
        saveAddressButon.setTitleColor(theme.colors.white, for: .normal)
        saveAddressButon.titleLabel?.font = theme.fonts.medium18
        saveAddressButon.backgroundColor = theme.colors.doorDashRed
        saveAddressButon.layer.cornerRadius = 4
        saveAddressButon.addTarget(self, action: #selector(saveAddressButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.height.equalTo(HeaderTextLabelView.height)
        }

        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(contentSize)
            make.top.equalTo(headerView.snp.bottom)
        }

        inputApartmentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(collectionView)
            make.height.equalTo(InputApartmentView.height)
            make.top.equalTo(collectionView.snp.bottom).offset(12)
        }

        saveAddressButon.snp.makeConstraints { (make) in
            make.top.equalTo(inputApartmentView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(inputApartmentView).inset(32)
            make.height.equalTo(55)
        }
    }

    private func setCurrentStyle(style: EnterAddressState) {
        self.navigationItem.setRightBarButton(rightNavBarButton, animated: false)
        switch style {
        case .disable:
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = theme.colors.lightGray
            self.inputApartmentView.isHidden = true
            self.saveAddressButon.isHidden = true
        case .enable:
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = theme.colors.darkGray
            self.inputApartmentView.isHidden = false
            self.saveAddressButon.isHidden = false
        case .hide:
            self.navigationItem.setRightBarButton(nil, animated: false)
        }
    }
}

extension SelectAddressViewController {

    @objc
    func saveAddressButtonTapped() {
        obtainDetailPlace()
    }

    @objc
    func rightNavBarButtonTapped() {
        obtainDetailPlace()
    }

    func obtainDetailPlace() {
        guard let prediction = viewModel.geoLocation else {
            return
        }
        self.loadingIndicator.show()
        viewModel.fetchDetailLocationInfo(prediction: prediction) { (location) in
            self.loadingIndicator.hide()
            guard let location = location else {
                print("Error: location does not exist")
                return
            }
            location.apartmentNumber = self.inputApartmentView.textField.text
            self.didSelectAddress?(location)
        }
    }
}

extension SelectAddressViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.data as! [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is String {
            let addressPresenter = EnterAddressSectionController(viewModel: viewModel)
            addressPresenter.cellDelegate = self
            return addressPresenter
        } else {
            let labelPresenter = AddressTextLabelSectionController()
            labelPresenter.cellTapped = { prediction in
                self.viewModel.confirmSelection(prediction: prediction)
                self.adapter.reloadData(completion: { _ in
                    self.updateCollectionViewHeight()
                    self.setCurrentStyle(style: .enable)
                })
            }
            return labelPresenter
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension SelectAddressViewController: EnterAddressCellDelegate {

    func updateCollectionViewHeight() {
        let cell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? EnterAddressCell
        cell?.separator.isHidden = self.viewModel.data.count <= 1
        self.collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(self.viewModel.contentHeight)
        }
        self.view.layoutIfNeeded()
    }

    func userDidEdited(text: String) {
        self.setCurrentStyle(style: .disable)
        self.viewModel.searchAddress(query: text, completion: {
            self.adapter.performUpdates(animated: false, completion: { _ in
                self.updateCollectionViewHeight()
            })
        })
    }
}

