//
//  CuratedCategoryHeaderCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 9/28/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class CuratedCategoryHeaderCell: UICollectionViewCell {

    let titleLabel: UILabel
    private let topSeparator: Separator
    private let bottomSeparator: Separator
    static let height: CGFloat = 70

    override init(frame: CGRect) {
        titleLabel = UILabel()
        topSeparator = Separator.create()
        bottomSeparator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CuratedCategoryHeaderCell {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.1)
        setupLabel()
        setupSeparators()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.darkGray
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium14
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupSeparators() {
        addSubview(topSeparator)
        addSubview(bottomSeparator)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        topSeparator.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.4)
        }

        bottomSeparator.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
}

