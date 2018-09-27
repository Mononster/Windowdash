//
//  BrowseFoodStoreDispalyCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class BrowseFoodStoreDispalyCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = CenterCardsCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        var insets = view.contentInset
        insets.left = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 4
        insets.right = insets.left
        view.contentInset = insets
        self.contentView.addSubview(view)
        return view
    }()

    private let storeNameLabel: UILabel
    private let priceAndCuisineLabel: UILabel
    private let ratingLabel: UILabel
    private let deliveryTimeLabel: UILabel
    private let deliveryCostLabel: UILabel

    static let heightWithMenu: CGFloat = 150 + 8 + 15 + 4 + 10 + 2 + 10 + 8
    static let heightWithoutMenu: CGFloat = 8 + 15 + 4 + 10 + 2 + 10 + 8

    override init(frame: CGRect) {
        storeNameLabel = UILabel()
        priceAndCuisineLabel = UILabel()
        ratingLabel = UILabel()
        deliveryTimeLabel = UILabel()
        deliveryCostLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let leading = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        collectionView.frame = CGRect(
            x: leading, y: 0, width: self.frame.width - 2 * leading, height: 150
        )
    }
}

extension BrowseFoodStoreDispalyCell {

    private func setupUI() {
        setupLabels()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(storeNameLabel)
        storeNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        storeNameLabel.font = ApplicationDependency.manager.theme.fontSchema.bold16
        storeNameLabel.textAlignment = .left
        storeNameLabel.adjustsFontSizeToFitWidth = true
        storeNameLabel.minimumScaleFactor = 0.5
        storeNameLabel.numberOfLines = 1

        setupLabel(label: priceAndCuisineLabel, textAlignment: .left)
        setupLabel(label: ratingLabel, textAlignment: .left)
        setupLabel(label: deliveryTimeLabel, textAlignment: .right)
        setupLabel(label: deliveryCostLabel, textAlignment: .right)
    }

    private func setupLabel(label: UILabel, textAlignment: NSTextAlignment) {
        addSubview(label)
        label.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        label.font = ApplicationDependency.manager.theme.fontSchema.medium12
        label.textAlignment = textAlignment
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
    }

    private func setupConstraints() {
        let leading = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        storeNameLabel.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().inset(leading)
            make.top.equalTo(collectionView.snp.bottom).offset(8)
        }

        priceAndCuisineLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(storeNameLabel)
            make.trailing.equalTo(self.snp.centerX)
            make.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        ratingLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(priceAndCuisineLabel)
            make.top.equalTo(priceAndCuisineLabel.snp.bottom).offset(2)
        }

        deliveryTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-leading)
            make.centerY.equalTo(priceAndCuisineLabel)
        }

        deliveryCostLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(deliveryTimeLabel)
            make.centerY.equalTo(ratingLabel)
            make.leading.equalTo(self.snp.centerX)
        }
    }
}
