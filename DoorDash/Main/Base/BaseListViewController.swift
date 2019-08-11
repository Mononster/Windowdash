//
//  BaseListViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

class BaseListViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    let collectionView: UICollectionView
    var sectionData: [ListDiffable] = []

    override init() {
        self.collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        super.init()
    }
}

extension BaseListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            view.layer.zPosition = -1
        }
    }
}
