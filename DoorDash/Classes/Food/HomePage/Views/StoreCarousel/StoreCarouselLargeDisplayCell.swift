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

    static let width: CGFloat = UIScreen.main.bounds.width - 2 * BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
    static let titleFont: UIFont = ApplicationDependency.manager.theme.fonts.bold18

    var didSelectItem: (() -> ())?

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

    static func getHeight(titleHeight: CGFloat) -> CGFloat {
        let heightWithoutTitleName = 2 + 200 + 10 + 5 + 20 + 10
        return CGFloat(heightWithoutTitleName) + titleHeight
    }

    func setupCell(model: StoreCarouselModelAlias) {
        self.title.text = model.title
        self.subTitle.text = model.subTitle
        self.cuisineImageView.layer.cornerRadius = 3
        self.cuisineImageView.setImage(
            placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRectBackground,
            regularURL: model.imageURL,
            highQualityURL: nil
        )
    }

    @objc func userTappedCell() {
        self.didSelectItem?()
    }
}

extension StoreCarouselLargeDisplayCell {

    private func setupUI() {
        setupImageView()
        setupLabels()
        setupConstraints()
        self.layoutIfNeeded()
        self.cuisineImageView.layer.cornerRadius = 3
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTappedCell))
        self.addGestureRecognizer(tap)
    }

    private func setupImageView() {
        addSubview(cuisineImageView)
        cuisineImageView.contentMode = .scaleAspectFill
        self.cuisineImageView.layer.masksToBounds = true
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        cuisineImageView.sd_imageTransition = transition
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.black
        title.font = StoreCarouselLargeDisplayCell.titleFont
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 3

        addSubview(subTitle)
        subTitle.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        subTitle.font = ApplicationDependency.manager.theme.fonts.medium14
        subTitle.textAlignment = .left
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.5
        subTitle.numberOfLines = 1
    }

    private func setupConstraints() {
        cuisineImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview().inset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.height.equalTo(200)
        }

        title.snp.makeConstraints { (make) in
            make.top.equalTo(cuisineImageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(cuisineImageView)
        }

        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.trailing.equalTo(cuisineImageView)
        }
    }
}


