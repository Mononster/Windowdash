//
//  ConfirmAddressTitleCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class ConfirmAddressTitleCell: UICollectionViewCell {

    static let height: CGFloat = 95
    private let titleLabel: UILabel
    private let subTitleLabel: UILabel

    override init(frame: CGRect) {
        titleLabel = UILabel()
        subTitleLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String, subTitle: String) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
}

extension ConfirmAddressTitleCell {

    private func setupUI() {
        setupTitleLabel()
        setupSubTitleLabel()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.font = ApplicationDependency.manager.theme.fonts.bold24
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
    }

    private func setupSubTitleLabel() {
        addSubview(subTitleLabel)
        subTitleLabel.backgroundColor = .clear
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 1
        subTitleLabel.minimumScaleFactor = 0.5
        subTitleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        subTitleLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.snp.centerY).offset(-2)
        }

        subTitleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.snp.centerY).offset(2)
        }
    }
}



