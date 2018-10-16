
//
//  OrderTwoTitlesButton.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OrderTwoTitlesButton: UIView {

    private let titleLabel: UILabel
    private let priceLabel: UILabel

    override init(frame: CGRect) {
        titleLabel = UILabel()
        priceLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTexts(title: String, price: String) {
        self.titleLabel.text = title
        self.priceLabel.text = price
    }
}

extension OrderTwoTitlesButton {

    private func setupUI() {
        self.isUserInteractionEnabled = true
        setupLabels()
        setupConstraints()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
    }

    private func setupLabels() {
        addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.white
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium18
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.isUserInteractionEnabled = true

        addSubview(priceLabel)
        priceLabel.backgroundColor = .clear
        priceLabel.textColor = ApplicationDependency.manager.theme.colors.white
        priceLabel.font = ApplicationDependency.manager.theme.fontSchema.medium18
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.numberOfLines = 1
        priceLabel.isUserInteractionEnabled = true
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.trailing.equalTo(priceLabel.snp.leading)
        }

        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
