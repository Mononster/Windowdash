//
//  CollectionFilterContainerView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/5/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class CollectionFilterContainerView: UICollectionViewCell {

    static let height: CGFloat = 220

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.backgroundColor = ApplicationDependency.manager.theme.colors.white
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        var insets = view.contentInset
        insets.left = 24
        insets.right = insets.left
        view.contentInset = insets
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
