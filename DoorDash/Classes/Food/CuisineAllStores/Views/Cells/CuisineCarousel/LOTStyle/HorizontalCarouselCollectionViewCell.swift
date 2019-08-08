//
//  HorizontalCarouselCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-11-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class HorizontalCarouselCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        var insets = view.contentInset
        insets.left = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 10
        insets.right = insets.left
        view.contentInset = insets
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }

    func setupCell(inset: UIEdgeInsets) {
        collectionView.contentInset = inset
    }
}


