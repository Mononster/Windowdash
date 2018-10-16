//
//  OrderCartItemCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import SwipeCellKit

final class OrderCartItemCollectionViewCell: SwipeCollectionViewCell {

    private let itemNameLabel: UILabel
    private let priceLabel: UILabel
    private let descriptionLabel: UILabel
    private let quantityLabel: UILabel
    private let separator: Separator

    static let heightWithoutDescription: CGFloat = 12 + 25 + 4 + 12
    static let descriptionLabelFont: UIFont = ApplicationDependency.manager.theme.fontSchema.medium12

    override init(frame: CGRect) {
        itemNameLabel = UILabel()
        priceLabel = UILabel()
        descriptionLabel = UILabel()
        quantityLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(quantity: String,
                   itemName: String,
                   itemDescription: String?,
                   price: String) {
        quantityLabel.text = quantity
        itemNameLabel.text = itemName
        descriptionLabel.text = itemDescription
        priceLabel.text = price

        descriptionLabel.snp.updateConstraints { (make) in
            let offset = itemDescription == nil ? -2 : 4
            make.top.equalTo(itemNameLabel.snp.bottom).offset(offset)
        }
    }
}

extension OrderCartItemCollectionViewCell {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupLabels()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabels() {
        setupQuantityLabel()
        setupItemNameLabel()
        setupItemDescriptionLabel()
        setupPriceLabel()
    }

    private func setupSeparator() {
        contentView.addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors
            .separatorGray
            .withAlphaComponent(0.8)
    }

    private func setupQuantityLabel() {
        contentView.addSubview(quantityLabel)
        quantityLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        quantityLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        quantityLabel.textAlignment = .center
        quantityLabel.adjustsFontSizeToFitWidth = true
        quantityLabel.minimumScaleFactor = 0.5
        quantityLabel.numberOfLines = 1
    }

    private func setupItemNameLabel() {
        contentView.addSubview(itemNameLabel)
        itemNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        itemNameLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        itemNameLabel.textAlignment = .left
        itemNameLabel.adjustsFontSizeToFitWidth = true
        itemNameLabel.minimumScaleFactor = 0.5
        itemNameLabel.numberOfLines = 1
    }

    private func setupItemDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        descriptionLabel.font = OrderCartItemCollectionViewCell.descriptionLabelFont
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }

    private func setupPriceLabel() {
        contentView.addSubview(priceLabel)
        priceLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        priceLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        quantityLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(OrderCartViewModel.UIStats.leadingSpace.rawValue)
        }

        itemNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(quantityLabel)
            make.leading.equalTo(quantityLabel.snp.trailing)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-8)
            make.height.equalTo(25)
        }

        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-OrderCartViewModel.UIStats.trailingSpace.rawValue)
            make.centerY.equalTo(quantityLabel)
            make.width.equalTo(50)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(itemNameLabel)
            make.trailing.equalTo(priceLabel)
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalTo(itemNameLabel.snp.bottom).offset(4)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalTo(itemNameLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
