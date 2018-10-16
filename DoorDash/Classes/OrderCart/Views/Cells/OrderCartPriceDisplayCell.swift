//
//  OrderCartPriceDisplayCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class OrderCartPriceDisplayCell: UICollectionViewCell {

    private let titleLabel: UILabel
    private let priceLabel: UILabel
    private let promoIndicatorLabel: UILabel
    private let infoImageView: UIImageView
    private let separator: Separator

    static let height: CGFloat = 30

    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.priceLabel = UILabel()
        self.promoIndicatorLabel = UILabel()
        self.infoImageView = UIImageView()
        self.separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String,
                   price: String,
                   showInfoIcon: Bool,
                   promoAppliedText: String?) {
        self.titleLabel.text = title
        self.infoImageView.isHidden = !showInfoIcon
        if let promoText = promoAppliedText {
            let textRange = NSMakeRange(0, price.count)
            let attributedText = NSMutableAttributedString(string: price)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                        value: 1, range: textRange)
            self.priceLabel.attributedText = attributedText
            self.promoIndicatorLabel.text = "  " + promoText
        } else {
            self.priceLabel.text = price
            self.promoIndicatorLabel.text = nil
        }
    }
}

extension OrderCartPriceDisplayCell {

    private func setupUI() {
        setupTitleLabel()
        setupInfoImageView()
        setupPriceLabel()
        setupPromoAppliedLabel()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupPriceLabel() {
        self.addSubview(priceLabel)
        priceLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        priceLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.numberOfLines = 1
    }

    private func setupInfoImageView() {
        addSubview(infoImageView)
        infoImageView.image = ApplicationDependency.manager.theme.imageAssets.lightgrayInfoIcon
        infoImageView.contentMode = .scaleAspectFit
    }

    private func setupPromoAppliedLabel() {
        addSubview(promoIndicatorLabel)
        promoIndicatorLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        promoIndicatorLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        promoIndicatorLabel.textAlignment = .right
        promoIndicatorLabel.adjustsFontSizeToFitWidth = true
        promoIndicatorLabel.minimumScaleFactor = 0.5
        promoIndicatorLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(OrderCartViewModel.UIStats.leadingSpace.rawValue)
        }

        infoImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.width.height.equalTo(14)
        }

        promoIndicatorLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-OrderCartViewModel.UIStats.trailingSpace.rawValue)
            make.centerY.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(promoIndicatorLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
}


