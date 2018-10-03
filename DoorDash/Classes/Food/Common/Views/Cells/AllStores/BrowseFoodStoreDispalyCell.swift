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
        return generateCollectionView()
    }()

    private let closeTimeLabel: UILabel
    private let storeNameLabel: UILabel
    private let priceAndCuisineLabel: UILabel
    private let ratingDescriptionLabel: UILabel
    private let ratingNumberLabel: UILabel
    private let ratingStarImageView: UIImageView
    private let deliveryTimeLabel: UILabel
    private let deliveryCostLabel: UILabel
    private let separator: Separator
    private let viewsToNotAdjustTag: Int = 100
    private let storeNameLabelTag: Int = 101

    var collectionViewHeight: CGFloat = 0
    static let heightWithMenu: CGFloat = 14 + 25 + 4 + 20 + 3 + 20 + 8
    static let heightWithoutMenu: CGFloat = BrowseFoodStoreDispalyCell.heightWithMenu - 14
    static let closeTimeHeight: CGFloat = 16

    override init(frame: CGRect) {
        closeTimeLabel = UILabel()
        storeNameLabel = UILabel()
        priceAndCuisineLabel = UILabel()
        ratingDescriptionLabel = UILabel()
        ratingNumberLabel = UILabel()
        ratingStarImageView = UIImageView()
        deliveryTimeLabel = UILabel()
        deliveryCostLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(
            x: 0, y: 0, width: self.frame.width, height: collectionViewHeight
        )
    }

    func updateUI(menuExists: Bool, closeTimeExists: Bool, isClosed: Bool) {
        let leading = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        closeTimeLabel.isHidden = !closeTimeExists
        collectionView.isHidden = !menuExists
        if menuExists {
            let topSpace = closeTimeExists ? BrowseFoodStoreDispalyCell.closeTimeHeight + 14 : 14
            storeNameLabel.snp.remakeConstraints { (make) in
                make.trailing.leading.equalToSuperview().inset(leading)
                make.top.equalTo(collectionView.snp.bottom).offset(topSpace)
            }
        } else {
            let topSpace = closeTimeExists ? BrowseFoodStoreDispalyCell.closeTimeHeight : 0
            storeNameLabel.snp.remakeConstraints { (make) in
                make.trailing.leading.equalToSuperview().inset(leading)
                make.top.equalToSuperview().offset(topSpace)
            }
        }
        adjustAlpha(isClosed: isClosed)
        self.layoutIfNeeded()
    }

    func setupCell(storeName: String,
                   priceAndCuisine: String,
                   rating: String?,
                   shouldHighlightRating: Bool,
                   ratingDescription: String,
                   deliveryTime: String,
                   deliveryCost: String,
                   closeTime: String?) {
        self.storeNameLabel.text = storeName
        self.priceAndCuisineLabel.text = priceAndCuisine
        self.ratingNumberLabel.text = rating
        self.ratingDescriptionLabel.text = ratingDescription
        self.ratingStarImageView.image = shouldHighlightRating ? ApplicationDependency.manager.theme.imageAssets.starHighlighted :
            ApplicationDependency.manager.theme.imageAssets.starDarkGray
        self.ratingNumberLabel.textColor = shouldHighlightRating ?
            ApplicationDependency.manager.theme.colors.doordashDarkCyan :
            ApplicationDependency.manager.theme.colors.doorDashDarkGray
        self.deliveryTimeLabel.text = deliveryTime
        self.deliveryCostLabel.text = deliveryCost
        self.closeTimeLabel.text = closeTime
    }
}

extension BrowseFoodStoreDispalyCell {

    private func setupUI() {
        setupLabels()
        setupImageView()
        setupSeparator()
        setupConstraints()
    }

    private func generateCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        var insets = view.contentInset
        insets.left = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        insets.right = insets.left
        view.contentInset = insets
        self.contentView.addSubview(view)
        return view
    }

    private func setupSeparator() {
        self.addSubview(separator)
    }

    private func setupImageView() {
        addSubview(ratingStarImageView)
        ratingStarImageView.contentMode = .scaleAspectFit
        ratingStarImageView.image = ApplicationDependency.manager.theme.imageAssets.starDarkGray
    }

    private func setupLabels() {
        addSubview(storeNameLabel)
        storeNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        storeNameLabel.font = ApplicationDependency.manager.theme.fontSchema.bold18
        storeNameLabel.textAlignment = .left
        storeNameLabel.adjustsFontSizeToFitWidth = true
        storeNameLabel.minimumScaleFactor = 0.5
        storeNameLabel.numberOfLines = 1
        storeNameLabel.tag = storeNameLabelTag

        addSubview(closeTimeLabel)
        closeTimeLabel.isHidden = true
        closeTimeLabel.textColor = ApplicationDependency.manager.theme.colors.doordashDarkCyan
        closeTimeLabel.font = ApplicationDependency.manager.theme.fontSchema.extraBold12
        closeTimeLabel.textAlignment = .left
        closeTimeLabel.adjustsFontSizeToFitWidth = true
        closeTimeLabel.minimumScaleFactor = 0.5
        closeTimeLabel.numberOfLines = 1
        closeTimeLabel.tag = viewsToNotAdjustTag

        setupLabel(label: ratingNumberLabel, textAlignment: .left)
        setupLabel(label: priceAndCuisineLabel, textAlignment: .left)
        setupLabel(label: ratingDescriptionLabel, textAlignment: .left)
        setupLabel(label: deliveryTimeLabel, textAlignment: .right)
        setupLabel(label: deliveryCostLabel, textAlignment: .right)
    }

    private func setupLabel(label: UILabel, textAlignment: NSTextAlignment) {
        addSubview(label)
        label.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        label.font = ApplicationDependency.manager.theme.fontSchema.medium14
        label.textAlignment = textAlignment
        label.numberOfLines = 1
    }

    private func setupConstraints() {
        let leading = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace

        closeTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(storeNameLabel.snp.top).offset(-2)
            make.leading.trailing.equalTo(storeNameLabel)
        }

        storeNameLabel.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().inset(leading)
            make.top.equalTo(collectionView.snp.bottom).offset(14)
        }

        priceAndCuisineLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(storeNameLabel)
            make.trailing.equalTo(self.snp.centerX)
            make.top.equalTo(storeNameLabel.snp.bottom).offset(4)
        }

        ratingNumberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(priceAndCuisineLabel)
            make.top.equalTo(priceAndCuisineLabel.snp.bottom).offset(3)
            make.height.equalTo(20)
        }

        ratingStarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.leading.equalTo(ratingNumberLabel.snp.trailing).offset(1)
            //make.top.equalTo(priceAndCuisineLabel.snp.bottom).offset(8)
            make.centerY.equalTo(ratingNumberLabel)
        }

        ratingDescriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(ratingStarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(ratingNumberLabel)
        }

        deliveryTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-leading)
            make.centerY.equalTo(priceAndCuisineLabel)
            make.leading.equalTo(self.snp.centerX)
        }

        deliveryCostLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(deliveryTimeLabel)
            make.centerY.equalTo(ratingDescriptionLabel)
            make.leading.equalTo(self.snp.centerX)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    private func adjustAlpha(isClosed: Bool) {
        if isClosed {
            for view in subviews {
                if view.tag != viewsToNotAdjustTag {
                    view.alpha = 0.7
                }
                if view.tag == storeNameLabelTag {
                    // more alpha adjust for black color
                    view.alpha = 0.5
                }
            }
        } else {
            for view in subviews {
                view.alpha = 1
            }
        }
    }
}
