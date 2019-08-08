//
//  BrowseFoodAllStoresHeaderView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 6/26/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class BrowseFoodAllStoresHeaderView: UICollectionViewCell {

    struct Constants {
        let height: CGFloat = 95
        let heightWithoutSeparator: CGFloat = 79
        let topSepatorHeight: CGFloat = 20
        let spaceBetweenTopSeparatorAndTitleLabel: CGFloat = 24
    }

    private let topSeparator: Separator
    private let titleLabel: UILabel
    private let separator: Separator

    private let constants = Constants()

    override init(frame: CGRect) {
        topSeparator = Separator.create()
        titleLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(text: String, showSeparator: Bool) {
        titleLabel.text = text
        topSeparator.isHidden = !showSeparator
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(topSeparator.snp.bottom).offset(showSeparator ? constants.spaceBetweenTopSeparatorAndTitleLabel : 4)
        }
    }
}

extension BrowseFoodAllStoresHeaderView {

    private func setupUI() {
        setupTopSeparator()
        setupLabel()
        setupSeparator()
        setupConstraints()
    }

    private func setupTopSeparator() {
        addSubview(topSeparator)
        topSeparator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.4)
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.extraBold18
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

        topSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topSeparator.snp.bottom).offset(24)
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

