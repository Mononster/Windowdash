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

enum NavigationBarButtonStyle {
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
    private let rightNavBarButton: UIBarButtonItem
    private let viewModel: SelectAddressViewModel

    private var contentSize: CGFloat {
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    override init() {
        viewModel = SelectAddressViewModel()
        headerView = HeaderTextLabelView(text: selectAddressHeader)
        rightNavBarButton = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: #selector(rightNavBarButtonTapped))
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
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

    @objc
    func rightNavBarButtonTapped() {

    }
}

extension SelectAddressViewController {

    private func setupUI() {
        self.view.backgroundColor = theme.colors.backgroundGray
        self.setNavBarButtonStyle(style: .disable)
        setupHeaderView()
        setupCollectionView()
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
    }

    private func setNavBarButtonStyle(style: NavigationBarButtonStyle) {
        self.navigationItem.setRightBarButton(rightNavBarButton, animated: false)
        switch style {
        case .disable:
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor : theme.colors.lightGray,
                 NSAttributedString.Key.font : theme.fontSchema.medium14],
                for: [.normal, .highlighted]
            )
            self.navigationItem.rightBarButtonItem?.tintColor = theme.colors.lightGray
        case .enable:
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor : theme.colors.doorDashRed,
                 NSAttributedString.Key.font : theme.fontSchema.medium14],
                for: [.normal, .highlighted]
            )
            self.navigationItem.rightBarButtonItem?.tintColor = theme.colors.doorDashRed
        case .hide:
            self.navigationItem.setRightBarButton(nil, animated: false)
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
                    self.setNavBarButtonStyle(style: .enable)
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
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func userDidEdited(text: String) {
        self.setNavBarButtonStyle(style: .disable)
        self.viewModel.searchAddress(query: text, completion: {
            self.adapter.performUpdates(animated: false, completion: { _ in
                self.updateCollectionViewHeight()
            })
        })
    }
}

