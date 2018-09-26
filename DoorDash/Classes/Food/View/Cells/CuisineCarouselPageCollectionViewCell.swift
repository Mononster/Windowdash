//
//  CuisineCarouselPageCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class CuisineCarouselPageCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = ListCollectionViewLayout(stickyHeaders: false, scrollDirection: .horizontal, topContentInset: 0, stretchToEdge: false)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
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

extension CuisineCarouselPageCollectionViewCell {

    private func setupUI() {
        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

