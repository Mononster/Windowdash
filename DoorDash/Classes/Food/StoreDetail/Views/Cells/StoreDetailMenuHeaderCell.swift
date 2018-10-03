//
//  StoreDetailMenuHeaderCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreDetailMenuHeaderCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let separator: Separator
    private let topSeparator: Separator
    static let heightWithoutDescription: CGFloat = 20 + 20 + 4 + 4 + 4
    static let descriptionLabelFont: UIFont = ApplicationDependency.manager.theme.fontSchema.medium14

    override init(frame: CGRect) {
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        separator = Separator.create()
        topSeparator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String,
                   description: String?,
                   hideTopSeparator: Bool = false) {
        self.titleLabel.text = title.uppercased()
        self.descriptionLabel.text = description
        self.topSeparator.isHidden = hideTopSeparator
    }
}

extension StoreDetailMenuHeaderCell {

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
        descriptionLabel.font = StoreDetailMenuHeaderCell.descriptionLabelFont
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.layer.cornerRadius = 2
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed

        addSubview(topSeparator)
        topSeparator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview().inset(
                StoreDetailViewModel.UIStats.leadingSpace
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
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
        }

        topSeparator.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(0.4)
            make.leading.trailing.equalToSuperview()
        }
    }
}


