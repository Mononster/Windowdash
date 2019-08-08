//
//  UserAccountPageTitleWithDescriptionCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class UserAccountPageTitleWithDescriptionCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let rightArrowImageView: UIImageView
    let separator: Separator
    
    static let height: CGFloat = 58

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.descriptionLabel = UILabel()
        self.rightArrowImageView = UIImageView()
        self.separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String,
                   description: String?) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}

extension UserAccountPageTitleWithDescriptionCell {

    private func setupUI() {
        setupTitleLabel()
        setupDescriptionLabel()
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

    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.gray
        descriptionLabel.font = ApplicationDependency.manager.theme.fonts.medium12
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 1
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
            make.bottom.equalTo(self.snp.centerY).offset(0)
            make.leading.equalToSuperview().offset(20)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY).offset(0)
            make.leading.equalTo(titleLabel)
        }

        rightArrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(rightArrowImageView.snp.width).multipliedBy(1.68)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

