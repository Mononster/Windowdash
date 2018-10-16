//
//  OrderCartAddMoreItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OrderCartAddMoreItemCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let separator: Separator

    static let height: CGFloat = 44
    
    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.separator = Separator.create()
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

extension OrderCartAddMoreItemCell {

    private func setupUI() {
        setupTitleLabel()
        setupSeparator()
        setupConstraints()
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors
            .separatorGray
            .withAlphaComponent(0.8)
    }


    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(OrderCartViewModel.UIStats.leadingSpace.rawValue)
            make.trailing.equalToSuperview().offset(-OrderCartViewModel.UIStats.trailingSpace.rawValue)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}

