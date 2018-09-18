//
//  EmbeddedCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class HorizontalScrollCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
        return view
    }()

    let pageControl: UIPageControl

    override init(frame: CGRect) {
        pageControl = UIPageControl()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HorizontalScrollCollectionViewCell {

    private func setupUI() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setupPageControl()
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-25)
        }
    }

    private func setupPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = ApplicationDependency.manager.theme.colors.doorDashLightGray
        pageControl.currentPageIndicatorTintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
    }
}
