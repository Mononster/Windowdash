//
//  PaymentMethodCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class PaymentMethodCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let selectedCheckmark: UIImageView
    private let separator: Separator

    static let height: CGFloat = 50

    override init(frame: CGRect) {
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        selectedCheckmark = UIImageView()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String,
                   description: String?,
                   isSelected: Bool) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        if isSelected {
            self.titleLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
            self.descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
            self.selectedCheckmark.isHidden = false
        } else {
            self.titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
            self.descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.darkGray
            self.selectedCheckmark.isHidden = true
        }
    }
}

extension PaymentMethodCell {

    private func setupUI() {
        setupLabel()
        setupCheckmark()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1

        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        descriptionLabel.font = ApplicationDependency.manager.theme.fonts.medium12
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
    }

    private func setupCheckmark() {
        addSubview(selectedCheckmark)
        selectedCheckmark.image = ApplicationDependency.manager.theme.imageAssets.redCheckMark
        selectedCheckmark.contentMode = .scaleAspectFit
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.6)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY).offset(-1)
            make.leading.equalToSuperview().offset(18)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(1)
            make.leading.equalTo(titleLabel)
        }

        selectedCheckmark.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(12)
            make.trailing.equalToSuperview().offset(-18)
        }

        separator.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.leading.equalTo(titleLabel).offset(-6)
            make.trailing.bottom.equalToSuperview()
        }
    }
}



