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

    struct Constants {
        let descriptionLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold16
        let quantityLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold16
        let quantityLabelWidth: CGFloat = 60
        let contentHorizontalSpace: CGFloat = 75
        let leadingSpace: CGFloat = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
        let orderCartImageViewSize: CGFloat = 26
        let contentLeadingTrailingSpace: CGFloat = 20
    }

    private let viewCartLabel: UILabel
    private let descriptionLabel: UILabel
    private let quantityLabel: UILabel
    private let orderCartImageView: UIImageView
    private let constants = Constants()

    override init(frame: CGRect) {
        viewCartLabel = UILabel()
        descriptionLabel = UILabel()
        quantityLabel = UILabel()
        orderCartImageView = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupText(description: String, quantity: String) {
        self.viewCartLabel.text = "VIEW CART"
        self.descriptionLabel.text = description
        self.quantityLabel.text = quantity
    }

    static func calcWidth(containerWidth: CGFloat, title: String) -> CGFloat {
        let constants = OrderCartThumbnailView.Constants()
        let textWidth = HelperManager.textWidth(title, font: constants.descriptionLabelFont)
        let maxWidth = containerWidth - 2 * constants.leadingSpace
        return min(maxWidth, 2 * constants.contentHorizontalSpace + textWidth)
    }
}

extension OrderCartThumbnailView {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        setupLabels()
        setupOrderCartImageView()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(viewCartLabel)
        viewCartLabel.textColor = ApplicationDependency.manager.theme.colors.white.withAlphaComponent(0.8)
        viewCartLabel.font = ApplicationDependency.manager.theme.fonts.extraBold10
        viewCartLabel.textAlignment = .center
        viewCartLabel.adjustsFontSizeToFitWidth = true
        viewCartLabel.minimumScaleFactor = 0.5
        viewCartLabel.numberOfLines = 1

        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.white
        descriptionLabel.font = constants.descriptionLabelFont
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 1
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.9

        addSubview(quantityLabel)
        quantityLabel.textColor = ApplicationDependency.manager.theme.colors.white
        quantityLabel.font = constants.quantityLabelFont
        quantityLabel.textAlignment = .right
        quantityLabel.numberOfLines = 1
        quantityLabel.adjustsFontSizeToFitWidth = true
        quantityLabel.minimumScaleFactor = 0.5
    }

    private func setupOrderCartImageView() {
        addSubview(orderCartImageView)
        orderCartImageView.image = ApplicationDependency.manager.theme.imageAssets.orderCartIcon
        orderCartImageView.contentMode = .scaleAspectFit
    }

    private func setupConstraints() {
        viewCartLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(constants.contentHorizontalSpace)
            make.bottom.equalTo(self.snp.centerY).offset(-4)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(viewCartLabel)
            make.top.equalTo(viewCartLabel.snp.bottom).offset(2)
        }

        quantityLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-constants.contentLeadingTrailingSpace)
            make.centerY.equalToSuperview()
            make.width.equalTo(constants.quantityLabelWidth)
        }

        orderCartImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(constants.contentLeadingTrailingSpace)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(constants.orderCartImageViewSize)
        }
    }
}
