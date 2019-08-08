//
//  NavigationAddressHeaderView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class NavigationAddressHeaderView: UIView {

    private let addressTitleLabel: UILabel
    let addressContentLabel: UILabel

    override init(frame: CGRect) {
        addressTitleLabel = UILabel()
        addressContentLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationAddressHeaderView {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupLabels()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(addressTitleLabel)
        addressTitleLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        addressTitleLabel.font = ApplicationDependency.manager.theme.fonts.heavy12
        addressTitleLabel.textAlignment = .natural
        addressTitleLabel.adjustsFontSizeToFitWidth = true
        addressTitleLabel.minimumScaleFactor = 0.5
        addressTitleLabel.numberOfLines = 1
        addressTitleLabel.text = "ADDRESS"

        addSubview(addressContentLabel)
        addressContentLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        addressContentLabel.font = ApplicationDependency.manager.theme.fonts.medium18
        addressContentLabel.textAlignment = .natural
        addressContentLabel.adjustsFontSizeToFitWidth = true
        addressContentLabel.minimumScaleFactor = 0.5
        addressContentLabel.numberOfLines = 1
        addressContentLabel.text = "730 7th St"
    }

    private func setupConstraints() {
        addressTitleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addressContentLabel.snp.top).offset(-2)
        }

        addressContentLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
