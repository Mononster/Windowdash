//
//  StoreDetailSwitchMenuCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreDetailSwitchMenuCell: UICollectionViewCell {

    private let currentMenuTypeLabel: UILabel
    private let switchMenuLabel: UILabel

    static let height: CGFloat = 16 + 25 + 16

    var userTappedSwitchMenu: (() -> ())?

    override init(frame: CGRect) {
        currentMenuTypeLabel = UILabel()
        switchMenuLabel = UILabel()
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchMenuLabelTapped))
        switchMenuLabel.addGestureRecognizer(tap)
    }

    @objc
    func switchMenuLabelTapped() {
        self.userTappedSwitchMenu?()
    }
}

extension StoreDetailSwitchMenuCell {

    private func setupUI() {
        setupLabels()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(currentMenuTypeLabel)
        currentMenuTypeLabel.textColor = ApplicationDependency.manager.theme.colors.black
        currentMenuTypeLabel.font = ApplicationDependency.manager.theme.fonts.extraBold17
        currentMenuTypeLabel.textAlignment = .left
        currentMenuTypeLabel.adjustsFontSizeToFitWidth = true
        currentMenuTypeLabel.minimumScaleFactor = 0.5
        currentMenuTypeLabel.numberOfLines = 1
        currentMenuTypeLabel.text = "FULL MENU"

        addSubview(switchMenuLabel)
        switchMenuLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        switchMenuLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        switchMenuLabel.textAlignment = .left
        switchMenuLabel.adjustsFontSizeToFitWidth = true
        switchMenuLabel.minimumScaleFactor = 0.5
        switchMenuLabel.numberOfLines = 1
        switchMenuLabel.text = "Switch Menu"
        switchMenuLabel.isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        currentMenuTypeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                StoreDetailViewModel.UIStats.leadingSpace
            )
            make.top.bottom.equalToSuperview().inset(16)
        }

        switchMenuLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(
                -StoreDetailViewModel.UIStats.leadingSpace
            )
            make.top.bottom.equalTo(currentMenuTypeLabel)
        }
    }
}
