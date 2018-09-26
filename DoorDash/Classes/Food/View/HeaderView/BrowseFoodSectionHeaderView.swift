//
//  BrowseFoodSectionHeaderViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class BrowseFoodSectionHeaderViewCell: UICollectionViewCell {

    let titleLabel: UILabel
    private let separator: Separator
    static let height: CGFloat = 60

    override init(frame: CGRect) {
        titleLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BrowseFoodSectionHeaderViewCell {

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
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.layer.cornerRadius = 2
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 2
            )
        }

        separator.snp.makeConstraints { (make) in
            make.height.equalTo(4)
            make.width.equalTo(35)
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
    }
}
