//
//  UserAccountPageTitleCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-22.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class UserAccountPageTitleCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let faqLabel: UILabel

    static let height: CGFloat = 80

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.faqLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserAccountPageTitleCell {

    private func setupUI() {
        setupTitleLabel()
        setupFaqLabel()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.bold30
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.text = "Account"
    }

    private func setupFaqLabel() {
        addSubview(faqLabel)
        faqLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        faqLabel.font = ApplicationDependency.manager.theme.fonts.medium18
        faqLabel.textAlignment = .left
        faqLabel.adjustsFontSizeToFitWidth = true
        faqLabel.minimumScaleFactor = 0.5
        faqLabel.numberOfLines = 1
        faqLabel.text = "FAQ"
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }

        faqLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(titleLabel)
        }
    }
}
