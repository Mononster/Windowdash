//
//  BrowseFoodStoreMenuImageCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

final class BrowseFoodStoreMenuImageCell: UICollectionViewCell {

    private let menuImageView: UIImageView

    override init(frame: CGRect) {
        menuImageView = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(imageURL: URL) {
        self.menuImageView.layer.cornerRadius = 3
        self.menuImageView.setImage(
            placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRectBackground,
            regularURL: imageURL,
            highQualityURL: nil
        )
    }
}

extension BrowseFoodStoreMenuImageCell {

    private func setupUI() {
        setupImageView()
        setupConstraints()
        self.layoutIfNeeded()
        self.menuImageView.layer.cornerRadius = 3
    }

    private func setupImageView() {
        addSubview(menuImageView)
        menuImageView.contentMode = .scaleAspectFill
        self.menuImageView.layer.masksToBounds = true
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        menuImageView.sd_imageTransition = transition
    }

    private func setupConstraints() {
        menuImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
