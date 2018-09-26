//
//  UserAccountViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-22.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

protocol UserAccountViewControllerDelegate: class {
    func showSignupForGuestUser()
    func userLoggedOut()
}

final class UserAccountViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let collectionView: UICollectionView
    private let viewModel: UserAccountViewModel

    weak var delegate: UserAccountViewControllerDelegate?

    override init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        viewModel = UserAccountViewModel(
            service: UserAPIService(),
            dataStore: ApplicationEnvironment.current.dataStore
        )
        super.init()
        adapter.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserProfile()
    }

    func fetchUserProfile() {
        guard let currUser = ApplicationEnvironment.current.currentUser else {
            log.error("User should exsist at this point, wtf happend?")
            return
        }
        if currUser.isGuest {
            self.delegate?.showSignupForGuestUser()
            return
        }
        self.pageLoadingIndicator.show()
        self.viewModel.fetchUserAccount { (errorMsg) in
            self.pageLoadingIndicator.hide()
            self.tableViewPlaceHolder.isHidden = true
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            self.adapter.performUpdates(animated: false)
        }
    }
}

extension UserAccountViewController {

    private func setupUI() {
        setupCollectionView()
        setupConstraints()
        tableViewPlaceHolder.isHidden = false
        self.view.bringSubviewToFront(tableViewPlaceHolder)
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = true
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.current.statusBarHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension UserAccountViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            viewModel.generateModelsForAccountDetails(),
            viewModel.generateModelsForNotifications(),
            viewModel.generateModelsForMoreSection(),
            viewModel.generateModelsForAppVersionSection()
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let model = object as? UserAccountPageSectionModel {
            switch model.type {
            case .account:
                return AccountDetailsSectionController()
            case .notifications:
                return AccountNotificationsSectionController()
            case .more:
                let sectionController = AccountMoreSectionController()
                sectionController.delegate = self
                return sectionController
            case .version:
                return AccountAppVersionSectionController()
            }
        }
        return AccountNotificationsSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension UserAccountViewController: AccountMoreSectionControllerDelegate {

    func userClickedLogout() {
        let alert = UIAlertController(title: "Are you sure", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Logout", style: .destructive , handler:{ (UIAlertAction)in
            ApplicationEnvironment.logout()
            self.delegate?.userLoggedOut()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true)
    }
}
