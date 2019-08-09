//
//  PickupMapTitleView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class CustomNavigationTitleView: UIView {

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}

final class PickupMapTitleView: UIView {

    struct Constants {
        let height: CGFloat = 45
        let addressLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold18
    }

    private let deliveryLabel: UILabel
    private let addressLabel: UILabel
    private let constants = Constants()

    override init(frame: CGRect) {
        deliveryLabel = UILabel()
        addressLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(address: String) {
        addressLabel.text = address
    }

    static func calcWidth(text: String) -> CGFloat {
        let addressWidth = HelperManager.textWidth(text, font: PickupMapTitleView.Constants().addressLabelFont) + 20
        return addressWidth
    }
}

extension PickupMapTitleView {

    private func setupUI() {
        setupLabels()
        setupConstraints()
    }

    private func setupLabels() {
        setupAddressLabel()
        setupDeliveryLabel()
    }

    private func setupAddressLabel() {
        addSubview(addressLabel)
        addressLabel.textColor = ApplicationDependency.manager.theme.colors.black
        addressLabel.font = constants.addressLabelFont
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
        deliveryLabel.text = "PICKUP NEAR"
    }

    private func setupConstraints() {
        deliveryLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        addressLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(deliveryLabel)
            make.top.equalTo(self.snp.centerY)
        }
    }
}
