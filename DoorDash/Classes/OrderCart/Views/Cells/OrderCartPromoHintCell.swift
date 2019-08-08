//
//  OrderCartPromoHintCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OrderCartPromoHintCell: UICollectionViewCell {

    private let container: UIView
    private let titleLabel: UILabel
    private let infoImageView: UIImageView

    static let height: CGFloat = 30

    override init(frame: CGRect) {
        self.container = UIView()
        self.titleLabel = UILabel()
        self.infoImageView = UIImageView()
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

extension OrderCartPromoHintCell {

    private func setupUI() {
        setupCointaner()
        setupTitleLabel()
        setupInfoImageView()
        setupConstraints()
    }

    private func setupTitleLabel() {
        container.addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupInfoImageView() {
        container.addSubview(infoImageView)
        infoImageView.image = ApplicationDependency.manager.theme.imageAssets.blackCircleInfoIcon
        infoImageView.contentMode = .scaleAspectFit
    }

    private func setupCointaner() {
        addSubview(container)
        container.backgroundColor = ApplicationDependency.manager.theme.colors.lightYellow
    }

    private func setupConstraints() {
        container.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(OrderCartViewModel.UIStats.leadingSpace.rawValue)
            make.trailing.equalToSuperview().offset(-OrderCartViewModel.UIStats.trailingSpace.rawValue)
            make.top.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalTo(infoImageView.snp.leading).offset(-4)
        }

        infoImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
    }
}


