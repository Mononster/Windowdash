//
//  UserAccountPageTitleAndValueCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class UserAccountPageTitleAndValueCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let valueLabel: UILabel
    private let rightArrowImageView: UIImageView
    let separator: Separator

    static let height: CGFloat = 58

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.valueLabel = UILabel()
        self.rightArrowImageView = UIImageView()
        self.separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String, value: String?, titleColor: UIColor = ApplicationDependency.manager.theme.colors.black) {
        self.titleLabel.text = title
        self.valueLabel.text = value
        if value == nil {
            self.valueLabel.isHidden = true
        }
        self.titleLabel.textColor = titleColor
    }
}

extension UserAccountPageTitleAndValueCell {

    private func setupUI() {
        setupTitleLabel()
        setupValueLabel()
        setupRightArrowImageView()
        setupSeparator()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupValueLabel() {
        addSubview(valueLabel)
        valueLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        valueLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        valueLabel.textAlignment = .left
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        valueLabel.numberOfLines = 1
    }

    private func setupRightArrowImageView() {
        addSubview(rightArrowImageView)
        rightArrowImageView.image = ApplicationDependency.manager.theme.imageAssets.rightArrowImage
        rightArrowImageView.contentMode = .scaleAspectFit
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }

        rightArrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(rightArrowImageView.snp.width).multipliedBy(1.68)
        }

        valueLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(rightArrowImageView.snp.leading).offset(-8)
            make.centerY.equalTo(titleLabel)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}


