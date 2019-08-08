//
//  StoreHorizontalCarouselCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 6/26/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class StoreHorizontalCarouselCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = ApplicationDependency.manager.theme.colors.white
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        var insets = view.contentInset
        insets.left = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        insets.right = insets.left
        view.contentInset = insets
        self.contentView.addSubview(view)
        return view
    }()

    let separator: Separator

    override init(frame: CGRect) {
        separator = Separator.create()
        super.init(frame: frame)
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.4)
        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
