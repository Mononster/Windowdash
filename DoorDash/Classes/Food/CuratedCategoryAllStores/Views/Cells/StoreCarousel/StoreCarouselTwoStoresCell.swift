//
//  StoreCarouselTwoStoresCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

final class StoreCarouselSingleStoreView: UIView {

    private let storeImageView: UIImageView
    private let title: UILabel
    private let subTitle: UILabel

    static let titleFont: UIFont = ApplicationDependency.manager.theme.fontSchema.bold16

    override init(frame: CGRect) {
        storeImageView = UIImageView()
        title = UILabel()
        subTitle = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    func setupView(model: StoreCarouselModelAlias) {
        self.title.text = model.title
        self.subTitle.text = model.subTitle
        self.storeImageView.layer.cornerRadius = 3
        self.storeImageView.setImage(
            placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRectBackground,
            regularURL: model.imageURL,
            highQualityURL: nil
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupImageView()
        setupLabels()
        setupConstraints()
        self.layoutIfNeeded()
        self.storeImageView.layer.cornerRadius = 3
    }

    private func setupImageView() {
        addSubview(storeImageView)
        storeImageView.contentMode = .scaleAspectFill
        self.storeImageView.layer.masksToBounds = true
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        storeImageView.sd_imageTransition = transition
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.black
        title.font = StoreCarouselSingleStoreView.titleFont
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 3

        addSubview(subTitle)
        subTitle.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        subTitle.font = ApplicationDependency.manager.theme.fontSchema.medium14
        subTitle.textAlignment = .left
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.5
        subTitle.numberOfLines = 1
    }

    private func setupConstraints() {
        storeImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(85)
        }

        title.snp.makeConstraints { (make) in
            make.top.equalTo(storeImageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }

        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
}

final class StoreCarouselTwoStoresCell: UICollectionViewCell {

    private let firstStore: StoreCarouselSingleStoreView
    private let secondStore: StoreCarouselSingleStoreView

    static let width: CGFloat = (UIScreen.main.bounds.width - 18 * 2 - 12) / 2

    override init(frame: CGRect) {
        firstStore = StoreCarouselSingleStoreView()
        secondStore = StoreCarouselSingleStoreView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func getHeight(titleHeight: CGFloat) -> CGFloat {
        let heightWithoutTitleName = 2 + 85 + 5 + 5 + 15 + 5
        return CGFloat(heightWithoutTitleName) + titleHeight
    }

    func setupCell(firstStoreModel: StoreCarouselModelAlias,
                   secondStoreModel: StoreCarouselModelAlias) {
        self.firstStore.setupView(model: firstStoreModel)
        self.secondStore.setupView(model: secondStoreModel)
    }
}

extension StoreCarouselTwoStoresCell {

    private func setupUI() {
        setupStores()
        setupConstraints()
    }

    private func setupStores() {
        addSubview(firstStore)
        addSubview(secondStore)
    }

    private func setupConstraints() {
        firstStore.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.width.equalTo(StoreCarouselTwoStoresCell.width)
            make.height.equalTo(50)
        }

        secondStore.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(
                -BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.width.equalTo(StoreCarouselTwoStoresCell.width)
            make.height.equalTo(50)
        }
    }
}



