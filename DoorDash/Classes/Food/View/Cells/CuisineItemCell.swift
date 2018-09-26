//
//  CuisineItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

final class CuisineItemCell: UICollectionViewCell {

    private let cuisineImageView: UIImageView
    private let title: UILabel

    override init(frame: CGRect) {
        cuisineImageView = UIImageView()
        title = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(imageURL: URL, title: String) {
        self.title.text = title
        self.cuisineImageView.layer.cornerRadius = cuisineImageView.frame.width / 2
        self.cuisineImageView.setImage(
            placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRoundBackground,
            regularURL: imageURL,
            highQualityURL: nil
        )
    }
}

extension CuisineItemCell {

    private func setupUI() {
        setupImageView()
        setupLabels()
        setupConstraints()
        self.layoutIfNeeded()
        self.cuisineImageView.layer.cornerRadius = cuisineImageView.frame.width / 2
    }

    private func setupImageView() {
        addSubview(cuisineImageView)
        cuisineImageView.contentMode = .scaleAspectFit
        self.cuisineImageView.layer.masksToBounds = true
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.doorDashGray
        title.font = ApplicationDependency.manager.theme.fontSchema.medium12
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 1
    }

    private func setupConstraints() {
        cuisineImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(cuisineImageView.snp.width)
        }

        title.snp.makeConstraints { (make) in
            make.top.equalTo(cuisineImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}

