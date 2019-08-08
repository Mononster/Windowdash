//
//  StoreCarouselDisplayCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 6/26/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import SDWebImage

final class StoreCarouselDisplayCell: UICollectionViewCell {

    private let cuisineImageView: UIImageView
    private let title: UILabel
    private let subTitle: UILabel

    static let width: CGFloat = UIScreen.main.bounds.width * 0.7
    static let titleFont: UIFont = ApplicationDependency.manager.theme.fonts.bold16

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

    static func getHeight() -> CGFloat {
        return 2 + 140 + 10 + 20 + 5 + 20 + 10
    }

    func setupCell(model: StoreHorizontalCarouselModelAlias) {
        self.title.text = model.title
        self.subTitle.text = model.subTitle
        self.cuisineImageView.layer.cornerRadius = 3
        if let imageURL = model.imageURL {
            cuisineImageView.setImage(
                placeHolder: ApplicationDependency.manager.theme.imageAssets.grayRectBackground,
                regularURL: imageURL,
                highQualityURL: nil
            )
        }
    }

    @objc func userTappedCell() {
        self.didSelectItem?()
    }
}

extension StoreCarouselDisplayCell {

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
        cuisineImageView.image = ApplicationDependency.manager.theme.imageAssets.grayRectBackground
        cuisineImageView.contentMode = .scaleAspectFill
        self.cuisineImageView.layer.masksToBounds = true
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        cuisineImageView.sd_imageTransition = transition
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.black
        title.font = StoreCarouselDisplayCell.titleFont
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
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
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
