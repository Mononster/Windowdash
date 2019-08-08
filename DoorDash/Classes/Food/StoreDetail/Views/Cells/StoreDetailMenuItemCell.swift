//
//  StoreDetailMenuItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

final class StoreDetailMenuItemCell: UICollectionViewCell {

    private let itemImageView: UIImageView
    private let itemNameLabel: UILabel
    private let itemDescriptionLabel: UILabel
    private let itemPriceLabel: UILabel
    private let popularIndicatorLabel: UILabel
    let separator: Separator

    static let menuItemImageViewHeight: CGFloat = 200
    static let descriptionLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.medium14

    override init(frame: CGRect) {
        itemImageView = UIImageView()
        itemNameLabel = UILabel()
        itemDescriptionLabel = UILabel()
        itemPriceLabel = UILabel()
        popularIndicatorLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(itemName: String,
                   itemPrice: String,
                   itemDescription: String?,
                   imageURL: URL?,
                   popularTag: String?) {
        self.itemNameLabel.text = itemName
        self.itemPriceLabel.text = itemPrice
        if let imageURL = imageURL {
            self.itemImageView.layer.cornerRadius = 3
            self.itemImageView.setImage(
                placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRectBackground,
                regularURL: imageURL,
                highQualityURL: nil
            )
        }
        self.itemDescriptionLabel.text = itemDescription
        self.popularIndicatorLabel.text = popularTag
        self.popularIndicatorLabel.isHidden = popularTag == nil
        updateCellConstraints(showItemImage: imageURL != nil)
    }

    private func updateCellConstraints(showItemImage: Bool) {
        self.popularIndicatorLabel.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(
                StoreDetailViewModel.UIStats.leadingSpace
            )
            if showItemImage {
                make.top.equalTo(itemImageView.snp.bottom).offset(12)
            } else {
                make.top.equalToSuperview().offset(16)
            }
        }
        self.itemImageView.isHidden = !showItemImage
    }
}

extension StoreDetailMenuItemCell {

    private func setupUI() {
        setupImageView()
        setupPopularTagLabel()
        setupNameLabel()
        setupDescriptionLabel()
        setupPriceLabel()
        setupSeparator()
        setupConstraints()
        self.layoutIfNeeded()
        itemImageView.layer.cornerRadius = 3
    }

    private func setupImageView() {
        addSubview(itemImageView)
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.masksToBounds = true
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        itemImageView.sd_imageTransition = transition
    }

    private func setupPopularTagLabel() {
        addSubview(popularIndicatorLabel)
        popularIndicatorLabel.isHidden = true
        popularIndicatorLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        popularIndicatorLabel.font = ApplicationDependency.manager.theme.fonts.extraBold12
        popularIndicatorLabel.textAlignment = .left
        popularIndicatorLabel.adjustsFontSizeToFitWidth = true
        popularIndicatorLabel.minimumScaleFactor = 0.5
        popularIndicatorLabel.numberOfLines = 1
    }

    private func setupNameLabel() {
        addSubview(itemNameLabel)
        itemNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        itemNameLabel.font = ApplicationDependency.manager.theme.fonts.bold18
        itemNameLabel.textAlignment = .left
        itemNameLabel.adjustsFontSizeToFitWidth = true
        itemNameLabel.minimumScaleFactor = 0.5
        itemNameLabel.numberOfLines = 1
    }

    private func setupDescriptionLabel() {
        addSubview(itemDescriptionLabel)
        itemDescriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        itemDescriptionLabel.font = StoreDetailMenuItemCell.descriptionLabelFont
        itemDescriptionLabel.textAlignment = .left
        itemDescriptionLabel.adjustsFontSizeToFitWidth = true
        itemDescriptionLabel.minimumScaleFactor = 0.5
        itemDescriptionLabel.numberOfLines = 0
    }

    private func setupPriceLabel() {
        addSubview(itemPriceLabel)
        itemPriceLabel.textColor = ApplicationDependency.manager.theme.colors.black
        itemPriceLabel.font = ApplicationDependency.manager.theme.fonts.medium15
        itemPriceLabel.textAlignment = .left
        itemPriceLabel.adjustsFontSizeToFitWidth = true
        itemPriceLabel.minimumScaleFactor = 0.5
        itemPriceLabel.numberOfLines = 1
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
    }

    private func setupConstraints() {
        itemImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(StoreDetailMenuItemCell.menuItemImageViewHeight)
            make.leading.trailing.equalToSuperview().inset(
                StoreDetailViewModel.UIStats.leadingSpace
            )
        }

        popularIndicatorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemImageView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(itemImageView)
        }

        itemNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(popularIndicatorLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(itemImageView)
        }

        itemDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(itemImageView)
        }

        itemPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemDescriptionLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(itemImageView)
        }

        separator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
}
