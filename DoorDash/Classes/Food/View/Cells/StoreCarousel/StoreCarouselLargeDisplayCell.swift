//
//  StoreCarouselLargeDisplayCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

typealias StoreCarouselModelAlias = (imageURL: URL, title: String, subTitle: String)

final class StoreCarouselLargeDisplayCell: UICollectionViewCell {

    private let cuisineImageView: UIImageView
    private let title: UILabel
    private let subTitle: UILabel

    static let height: CGFloat = 2 + 180 + 10 + 20 + 5 + 20 + 5
    static let width: CGFloat = UIScreen.main.bounds.width - 2 * BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
    static let titleFont: UIFont = ApplicationDependency.manager.theme.fontSchema.bold18

    override init(frame: CGRect) {
        cuisineImageView = UIImageView()
        title = UILabel()
        subTitle = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(model: StoreCarouselModelAlias) {
        self.title.text = model.title
        self.subTitle.text = model.subTitle
        self.cuisineImageView.layer.cornerRadius = 4
        self.cuisineImageView.setImage(
            placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRectBackground,
            regularURL: model.imageURL,
            highQualityURL: nil
        )
    }
}

extension StoreCarouselLargeDisplayCell {

    private func setupUI() {
        setupImageView()
        setupLabels()
        setupConstraints()
        self.layoutIfNeeded()
        self.cuisineImageView.layer.cornerRadius = 4
    }

    private func setupImageView() {
        addSubview(cuisineImageView)
        cuisineImageView.contentMode = .scaleAspectFill
        self.cuisineImageView.layer.masksToBounds = true
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.black
        title.font = StoreCarouselLargeDisplayCell.titleFont
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 1

        addSubview(subTitle)
        subTitle.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        subTitle.font = ApplicationDependency.manager.theme.fontSchema.medium12
        subTitle.textAlignment = .left
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.5
        subTitle.numberOfLines = 1
    }

    private func setupConstraints() {
        cuisineImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }

        title.snp.makeConstraints { (make) in
            make.top.equalTo(cuisineImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }

        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
}


