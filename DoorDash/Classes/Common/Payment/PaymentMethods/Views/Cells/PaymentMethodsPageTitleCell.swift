//
//  PaymentMethodsPageTitleCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class PaymentMethodsPageTitleCell: UICollectionViewCell {

    private let titleLabel: UILabel
    static let height: CGFloat = 100

    override init(frame: CGRect) {
        titleLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String) {
        self.titleLabel.text = title
    }
}

extension PaymentMethodsPageTitleCell {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupLabel()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        titleLabel.font = ApplicationDependency.manager.theme.fonts.medium14
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(18)
        }
    }
}




