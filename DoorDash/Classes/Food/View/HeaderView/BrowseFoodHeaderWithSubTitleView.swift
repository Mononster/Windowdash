//
//  BrowseFoodHeaderWithSubTitleViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class BrowseFoodHeaderWithSubTitleViewCell: UICollectionViewCell {

    let titleLabel: UILabel
    let descriptionLabel: UILabel
    private let separator: Separator
    static let height: CGFloat = 90

    override init(frame: CGRect) {
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrowseFoodHeaderWithSubTitleViewCell {

    private func setupUI() {
        setupLabel()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.extraBold18
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1

        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        descriptionLabel.font = ApplicationDependency.manager.theme.fontSchema.medium14
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 1
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.layer.cornerRadius = 2
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }

        separator.snp.makeConstraints { (make) in
            make.height.equalTo(4)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(35)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(2)
        }
    }
}

