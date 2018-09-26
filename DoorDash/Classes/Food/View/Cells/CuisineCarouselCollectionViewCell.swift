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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
//        layout.itemSize = CGSize(
//            width: self.frame.width - 2 * BrowseFoodViewModel.UIConfigure.homePageLeadingSpace,
//            height: CuisineItemSectonController.heightWithoutImage + BrowseFoodViewModel.UIConfigure.getCuisineItemSize(collectionViewWidth: self.frame.width)
//        )
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        self.contentView.addSubview(view)
//        view.contentInset = UIEdgeInsets(
//            top: 0, left: BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 8,
//            bottom: 0, right: BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 8
//        )
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CuisineCarouselCollectionViewCell {

    private func setupUI() {
        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

