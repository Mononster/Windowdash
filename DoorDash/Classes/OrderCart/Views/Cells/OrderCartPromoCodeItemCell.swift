//
//  OrderCartPromoCodeItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OrderCartPromoCodeItemCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let rightArrowImageView: UIImageView
    private let separator: Separator

    static let height: CGFloat = 44

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.separator = Separator.create()
        self.rightArrowImageView = UIImageView()
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

extension OrderCartPromoCodeItemCell {

    private func setupUI() {
        setupTitleLabel()
        setupRightArrowImageView()
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
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupRightArrowImageView() {
        addSubview(rightArrowImageView)
        rightArrowImageView.image = ApplicationDependency.manager.theme.imageAssets.rightArrowImage
        rightArrowImageView.contentMode = .scaleAspectFit
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

        rightArrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(titleLabel)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(rightArrowImageView.snp.width).multipliedBy(1.68)
        }
    }
}


