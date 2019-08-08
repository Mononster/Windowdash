//
//  UserAccountPageTitleAndToggleCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class UserAccountPageTitleAndToggleCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let switchView: UISwitch
    let separator: Separator

    static let height: CGFloat = 58

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.switchView = UISwitch()
        self.separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String, isOn: Bool) {
        self.titleLabel.text = title
        self.switchView.setOn(isOn, animated: false)
    }
}

extension UserAccountPageTitleAndToggleCell {

    private func setupUI() {
        setupTitleLabel()
        setupUISwitch()
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

    private func setupUISwitch() {
        addSubview(switchView)
        switchView.onTintColor = ApplicationDependency.manager.theme.colors.doorDashRed
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

        switchView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(titleLabel)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}



