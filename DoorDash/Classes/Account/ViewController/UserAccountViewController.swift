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
    func showPageForType(type: UserAccountPageType)
}

final class UserAccountViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        return ListAdapter(updater: updater, viewController: self)
    }()

    private let collectionView: UICollectionView
    private let viewModel: UserAccountViewModel
    private var sectionData: [ListDiffable] = []

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            self.sectionData = [
                self.viewModel.generateModelsForAccountDetails(),
                self.viewModel.generateModelsForNotifications(),
                self.viewModel.generateModelsForMoreSection(),
                self.viewModel.generateModelsForAppVersionSection()
            ]
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                return
            }
            self.adapter.performUpdates(animated: true, completion: { _ in
                //self.animateCells()
            })
        }
    }

    private func animateCells() {
        for (i, cell) in collectionView.orderedVisibleCells.enumerated() {
            let originX = cell.frame.minX
            cell.frame = CGRect(x: -cell.frame.width, y: cell.frame.minY, width: cell.frame.width, height: cell.frame.height)
            UIView.animate(withDuration: 0.3, delay: Double(i) * 0.15, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
                cell.frame = CGRect(x: originX, y: cell.frame.minY, width: cell.frame.width, height: cell.frame.height)
            }, completion: nil)
//            UIView.animate(withDuration: 1) {
//
//            }
        }
    }
}

extension UserAccountViewController {

    private func setupUI() {
        setupCollectionView()
        setupConstraints()
        tableViewPlaceHolder.isHidden = true
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
        return sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let model = object as? UserAccountPageSectionModel {
            switch model.type {
            case .account:
                let controller = AccountDetailsSectionController()
                controller.userTappedSection = userTappedSection
                return controller
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

extension UserAccountViewController {

    private func userTappedSection(type: UserAccountPageType) {
        self.delegate?.showPageForType(type: type)
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

public extension UICollectionView {

    /// VisibleCells in the order they are displayed on screen.
    var orderedVisibleCells: [UICollectionViewCell] {
        return indexPathsForVisibleItems.sorted().compactMap { cellForItem(at: $0) }
    }

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UICollectionViewCells in the argument section.
    func visibleCells(in section: Int) -> [UICollectionViewCell] {
        return visibleCells.filter { indexPath(for: $0)?.section == section }
    }
}
