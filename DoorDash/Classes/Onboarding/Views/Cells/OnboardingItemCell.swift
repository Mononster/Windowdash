//
//  OnboardingItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OnboardingItemCell: UICollectionViewCell {

    private let onboardingImageView: UIImageView
    private let title: UILabel
    private let subTitle: UILabel

    override init(frame: CGRect) {
        onboardingImageView = UIImageView()
        title = UILabel()
        subTitle = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(image: UIImage, title: String, subTitle: String) {
        self.onboardingImageView.image = image
        self.title.text = title
        self.subTitle.text = subTitle
    }
}

extension OnboardingItemCell {

    private func setupUI() {
        setupImageView()
        setupLabels()
        setupConstraints()
    }

    private func setupImageView() {
        addSubview(onboardingImageView)
        onboardingImageView.contentMode = .scaleAspectFit
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        title.font = ApplicationDependency.manager.theme.fontSchema.bold18
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 1

        addSubview(subTitle)
        subTitle.textColor = ApplicationDependency.manager.theme.colors.gray
        subTitle.font = ApplicationDependency.manager.theme.fontSchema.regular18
        subTitle.textAlignment = .center
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.5
        subTitle.numberOfLines = 0
    }

    private func setupConstraints() {
        onboardingImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-2 * 12)
            make.height.equalTo(onboardingImageView.snp.width)
        }

        title.snp.makeConstraints { (make) in
            make.top.equalTo(onboardingImageView.snp.bottom).offset(-4)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }

        subTitle.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(18)
            make.top.equalTo(title.snp.bottom).offset(6)
        }
    }
}
