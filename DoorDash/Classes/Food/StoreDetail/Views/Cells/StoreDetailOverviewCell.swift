//
//  StoreDetailOverviewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreDetailOverviewCell: UICollectionViewCell {

    private let storeNameLabel: UILabel
    private let storeDesriptionLabel: UILabel
    private let ratingStars: CosmosView
    private let ratingNumberLabel: UILabel

    static let heightWithoutLabels: CGFloat = 8 + 10 + 8 + 20 + 8
    static let nameFont: UIFont = ApplicationDependency.manager.theme.fonts.bold30
    static let descriptionFont: UIFont = ApplicationDependency.manager.theme.fonts.medium16

    override init(frame: CGRect) {
        storeNameLabel = UILabel()
        storeDesriptionLabel = UILabel()
        ratingStars = CosmosView()
        ratingNumberLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(name: String,
                   description: String,
                   ratingText: String,
                   ratingNum: Double) {
        self.storeNameLabel.text = name
        self.storeDesriptionLabel.text = description
        self.ratingNumberLabel.text = ratingText
        self.ratingStars.rating = ratingNum
    }
}

extension StoreDetailOverviewCell {

    private func setupUI() {
        setupLabels()
        setupRatingStars()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(storeNameLabel)
        storeNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        storeNameLabel.font = StoreDetailOverviewCell.nameFont
        storeNameLabel.textAlignment = .left
        storeNameLabel.adjustsFontSizeToFitWidth = true
        storeNameLabel.minimumScaleFactor = 0.5
        storeNameLabel.numberOfLines = 3

        addSubview(storeDesriptionLabel)
        storeDesriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        storeDesriptionLabel.font = StoreDetailOverviewCell.descriptionFont
        storeDesriptionLabel.textAlignment = .left
        storeDesriptionLabel.adjustsFontSizeToFitWidth = true
        storeDesriptionLabel.minimumScaleFactor = 0.5
        storeDesriptionLabel.numberOfLines = 3
    }

    private func setupRatingStars() {
        addSubview(ratingStars)
        ratingStars.emptyImage = ApplicationDependency.manager.theme.imageAssets.ratingStarEmpty
        ratingStars.filledImage = ApplicationDependency.manager.theme.imageAssets.ratingStarFull
        ratingStars.isUserInteractionEnabled = false

        addSubview(ratingNumberLabel)
        ratingNumberLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        ratingNumberLabel.font = ApplicationDependency.manager.theme.fonts.medium14
        ratingNumberLabel.textAlignment = .left
        ratingNumberLabel.adjustsFontSizeToFitWidth = true
        ratingNumberLabel.minimumScaleFactor = 0.5
        ratingNumberLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        storeNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(
                StoreDetailViewModel.UIStats.leadingSpace
            )
        }

        storeDesriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(storeNameLabel)
        }

        ratingStars.snp.makeConstraints { (make) in
            make.top.equalTo(storeDesriptionLabel.snp.bottom).offset(8)
            make.height.equalTo(CosmosDefaultSettings.starSize)
            make.width.equalTo(
                5 * CosmosDefaultSettings.starSize + 4 * CosmosDefaultSettings.starMargin
            )
            make.leading.equalTo(storeDesriptionLabel)
        }

        ratingNumberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(ratingStars.snp.trailing).offset(8)
            make.centerY.equalTo(ratingStars)
            make.trailing.equalTo(storeDesriptionLabel)
        }
    }
}
