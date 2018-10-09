//
//  OrderCartThumbnailView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-04.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OrderCartThumbnailView: UIView {

    private let viewCartLabel: UILabel
    private let descriptionLabel: UILabel

    override init(frame: CGRect) {
        viewCartLabel = UILabel()
        descriptionLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupText(description: String) {
        self.viewCartLabel.text = "VIEW CART"
        self.descriptionLabel.text = description
    }
}

extension OrderCartThumbnailView {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        setupLabels()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(viewCartLabel)
        viewCartLabel.textColor = ApplicationDependency.manager.theme.colors.white.withAlphaComponent(0.9)
        viewCartLabel.font = ApplicationDependency.manager.theme.fontSchema.bold10
        viewCartLabel.textAlignment = .center
        viewCartLabel.adjustsFontSizeToFitWidth = true
        viewCartLabel.minimumScaleFactor = 0.5
        viewCartLabel.numberOfLines = 1

        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.white
        descriptionLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        viewCartLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(self.snp.centerY).offset(-4)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(viewCartLabel)
            make.top.equalTo(viewCartLabel.snp.bottom).offset(2)
        }
    }
}
