//
//  RefineLocationTitleCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class RefineLocationTitleCell: UICollectionViewCell {

    private let titleLabel: UILabel
    static let height: CGFloat = 19

    override init(frame: CGRect) {
        titleLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RefineLocationTitleCell {

    private func setupUI() {
        setupTitleLabel()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium15
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.text = "Refine your location by dragging the pin."
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
    }
}
