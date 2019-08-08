//
//  ItemDetailOptionHeaderCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class ItemDetailOptionHeaderCell: UICollectionViewCell {

    private let nameLabel: UILabel
    private let descriptionLabel: UILabel
    private let requiredLabel: PaddingLabel

    static let descriptionLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.medium16

    override init(frame: CGRect) {
        nameLabel = UILabel()
        descriptionLabel = UILabel()
        requiredLabel = PaddingLabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(name: String, description: String?, isRequired: Bool) {
        self.nameLabel.text = name
        self.descriptionLabel.text = description

        let leading = ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue
        self.descriptionLabel.isHidden = description == nil
        self.requiredLabel.isHidden = !isRequired
        if description != nil {
            nameLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(leading)
                make.bottom.equalTo(self.snp.centerY)
                make.trailing.equalTo(requiredLabel.snp.leading).offset(-8)
            }
            descriptionLabel.snp.remakeConstraints { (make) in
                make.leading.equalTo(nameLabel)
                make.top.equalTo(self.snp.centerY).offset(10)
                make.trailing.equalToSuperview().offset(-leading)
            }
        } else {
            nameLabel.snp.remakeConstraints { (make) in
                make.leading.equalToSuperview().offset(leading)
                make.top.equalToSuperview().offset(32)
                make.trailing.equalTo(requiredLabel.snp.leading).offset(-8)
            }
        }
    }
}

extension ItemDetailOptionHeaderCell {

    private func setupUI() {
        setupLabels()
        setupRequiredLabel()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(nameLabel)
        nameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        nameLabel.font = ApplicationDependency.manager.theme.fonts.extraBold17
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.numberOfLines = 1

        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        descriptionLabel.font = ItemDetailOptionHeaderCell.descriptionLabelFont
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
        descriptionLabel.isHidden = true
    }

    private func setupRequiredLabel() {
        addSubview(requiredLabel)
        requiredLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        requiredLabel.font = ApplicationDependency.manager.theme.fonts.medium14
        requiredLabel.textAlignment = .right
        requiredLabel.adjustsFontSizeToFitWidth = true
        requiredLabel.minimumScaleFactor = 0.5
        requiredLabel.numberOfLines = 1
        requiredLabel.backgroundColor = ApplicationDependency.manager.theme.colors.lightYellow
        requiredLabel.isHidden = true
        requiredLabel.text = "Required"
        requiredLabel.layer.cornerRadius = 4
        requiredLabel.layer.masksToBounds = true
    }

    private func setupConstraints() {
        let leading = ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(leading)
            make.top.equalToSuperview().offset(32)
            make.trailing.equalTo(requiredLabel.snp.leading).offset(-8)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
        }

        requiredLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-leading)
            make.centerY.equalTo(nameLabel)
        }
    }
}
