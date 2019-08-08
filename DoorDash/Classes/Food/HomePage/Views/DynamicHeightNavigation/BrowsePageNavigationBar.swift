//
//  BrowsePageNavigationBar.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-31.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class AddressHeadlineView: UIView {

    private let deliveryLabel: UILabel
    private let addressLabel: UILabel
    private let dropDownIndicator: UIImageView

    static let height: CGFloat = 45
    static let addressLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold18

    override init(frame: CGRect) {
        deliveryLabel = UILabel()
        addressLabel = UILabel()
        dropDownIndicator = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(address: String) {
        self.addressLabel.text = address
    }

    static func calcHeight(text: String) -> CGFloat {
        let addressWidth = HelperManager.textWidth(text, font: addressLabelFont) + 22
        return addressWidth
    }
}

extension AddressHeadlineView {

    private func setupUI() {
        setupLabels()
        setupDropDownIndicator()
        setupConstraints()
    }

    private func setupLabels() {
        setupAddressLabel()
        setupDeliveryLabel()
    }

    private func setupAddressLabel() {
        addSubview(addressLabel)
        addressLabel.textColor = ApplicationDependency.manager.theme.colors.black
        addressLabel.font = AddressHeadlineView.addressLabelFont
        addressLabel.textAlignment = .right
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.minimumScaleFactor = 0.5
        addressLabel.numberOfLines = 1
    }

    private func setupDeliveryLabel() {
        addSubview(deliveryLabel)
        deliveryLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        deliveryLabel.font = ApplicationDependency.manager.theme.fonts.extraBold10
        deliveryLabel.textAlignment = .center
        deliveryLabel.adjustsFontSizeToFitWidth = true
        deliveryLabel.minimumScaleFactor = 0.5
        deliveryLabel.numberOfLines = 1
        deliveryLabel.text = "DELIVER TO"
    }

    private func setupDropDownIndicator() {
        addSubview(dropDownIndicator)
        dropDownIndicator.contentMode = .scaleAspectFit
        dropDownIndicator.image = ApplicationDependency.manager.theme.imageAssets.dropDownIndicator
    }

    private func setupConstraints() {
        deliveryLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        addressLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalTo(dropDownIndicator.snp.leading).offset(-6)
            make.top.equalTo(self.snp.centerY)
        }

        dropDownIndicator.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-6)
            make.width.equalTo(10)
            make.height.equalTo(8)
            make.centerY.equalTo(addressLabel).offset(1)
        }
    }
}

final class BrowsePageNavigationBar: UIView {

    let addressView: AddressHeadlineView
    let numShopLabel: UILabel
    private let separator: Separator

    override init(frame: CGRect) {
        addressView = AddressHeadlineView()
        numShopLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBy(offset: CGFloat, navigattionBarMinHeight: CGFloat) {
        self.transform = CGAffineTransform(
            translationX: 0,
            y: -offset
        )

        self.addressView.layer.opacity = Float(1 - offset / (navigattionBarMinHeight))
        self.numShopLabel.layer.opacity = Float(offset / (navigattionBarMinHeight + 2))
    }

    func adjustBySrollView(offsetY: CGFloat,
                           previousOffset: CGFloat,
                           navigattionBarMinHeight: CGFloat) {
        if offsetY <= navigattionBarMinHeight && offsetY > 0 {
            self.updateBy(offset: offsetY, navigattionBarMinHeight: navigattionBarMinHeight)
        }
        if previousOffset < navigattionBarMinHeight && offsetY >= navigattionBarMinHeight {
            self.updateBy(offset: navigattionBarMinHeight,
                          navigattionBarMinHeight: navigattionBarMinHeight)
        }
        if previousOffset > 0 && offsetY < 0 {
            self.updateBy(offset: 0, navigattionBarMinHeight: navigattionBarMinHeight)
        }

        if offsetY <= 0 {
            self.addressView.layer.opacity = 1
            self.numShopLabel.layer.opacity = 0
        }

        if offsetY == 0 {
            self.transform = CGAffineTransform.identity
        }
    }

    func updateTexts(address: String, numShops: String) {
        numShopLabel.text = numShops
        addressView.setupView(address: address)
        addressView.snp.updateConstraints { (make) in
            make.width.equalTo(AddressHeadlineView.calcHeight(text: address))
        }
    }
}

extension BrowsePageNavigationBar {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        addSubview(separator)
        separator.alpha = 0.6
        setupTitleLabel()
        setupAddressView()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(numShopLabel)
        numShopLabel.textColor = ApplicationDependency.manager.theme.colors.black
        numShopLabel.font = ApplicationDependency.manager.theme.fonts.extraBold10
        numShopLabel.adjustsFontSizeToFitWidth = true
        numShopLabel.minimumScaleFactor = 0.5
        numShopLabel.numberOfLines = 1
        numShopLabel.textAlignment = .center
        numShopLabel.layer.opacity = 0
    }

    private func setupAddressView() {
        addSubview(addressView)
        addressView.backgroundColor = .clear
    }

    private func setupConstraints() {
        addressView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(AddressHeadlineView.height)
            make.width.equalTo(100)
        }

        numShopLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }

        separator.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
}
