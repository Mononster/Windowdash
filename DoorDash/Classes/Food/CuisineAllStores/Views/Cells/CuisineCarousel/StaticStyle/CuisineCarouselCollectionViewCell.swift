//
//  CuisineCarouselCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class CuisineCarouselCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = CenterCardsCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        var insets = view.contentInset
        insets.left = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 4
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

