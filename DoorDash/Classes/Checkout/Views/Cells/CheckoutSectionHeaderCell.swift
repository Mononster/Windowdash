//
//  CheckoutSectionHeaderCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class CheckoutSectionHeaderCell: UICollectionViewCell {

    private let titleLabel: UILabel

    static let height: CGFloat = 50

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
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

extension CheckoutSectionHeaderCell {

    private func setupUI() {
        setupTitleLabel()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.extraBold16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(
                CheckoutViewModel.UIStats.leadingSpace.rawValue
            )
        }
    }
}


