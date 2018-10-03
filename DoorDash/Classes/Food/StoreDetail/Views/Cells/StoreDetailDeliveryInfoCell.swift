//
//  StoreDetailDeliveryInfoCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreDetailDeliveryInfoCell: UICollectionViewCell {

    private let moneyValueLabel: UILabel
    private let moneyIndicatorLabel: UILabel
    private let timeValueLabel: UILabel
    private let timeIndicatorLabel: UILabel
    private let distanceValueLabel: UILabel
    private let distanceIndicatorLabel: UILabel
    private let deliveryTypeControl: UISegmentedControl

    static let height: CGFloat = 2 + 20 + 20 + 16

    override init(frame: CGRect) {
        moneyValueLabel = UILabel()
        moneyIndicatorLabel = UILabel()
        timeValueLabel = UILabel()
        timeIndicatorLabel = UILabel()
        distanceValueLabel = UILabel()
        distanceIndicatorLabel = UILabel()
        deliveryTypeControl = UISegmentedControl(items: ["Delivery", "Pickup"])
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(deliveryFeeDisplay: String,
                   timeDispaly: String,
                   distanceDisplay: String,
                   offerPickUp: Bool) {
        self.moneyValueLabel.text = deliveryFeeDisplay
        self.timeValueLabel.text = timeDispaly
        self.distanceValueLabel.text = distanceDisplay

        self.moneyIndicatorLabel.text = "delivery"
        self.timeIndicatorLabel.text = "min"
        self.distanceIndicatorLabel.text = "miles"

        self.deliveryTypeControl.isHidden = !offerPickUp
    }
}

extension StoreDetailDeliveryInfoCell {

    private func setupUI() {
        setupIndicatorLabels()
        setupValueLabels()
        setupTypeControl()
        setupConstraints()
    }

    private func setupIndicatorLabels() {
        setupIndicatorLabel(label: moneyIndicatorLabel)
        setupIndicatorLabel(label: timeIndicatorLabel)
        setupIndicatorLabel(label: distanceIndicatorLabel)
    }

    private func setupIndicatorLabel(label: UILabel) {
        addSubview(label)
        label.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        label.font = ApplicationDependency.manager.theme.fontSchema.medium14
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
    }

    private func setupValueLabels() {
        setupValueLabel(label: moneyValueLabel)
        setupValueLabel(label: timeValueLabel)
        setupValueLabel(label: distanceValueLabel)
    }

    private func setupValueLabel(label: UILabel) {
        addSubview(label)
        label.textColor = ApplicationDependency.manager.theme.colors.black
        label.font = ApplicationDependency.manager.theme.fontSchema.bold17
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
    }

    private func setupTypeControl() {
        addSubview(deliveryTypeControl)
        deliveryTypeControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: ApplicationDependency.manager.theme.fontSchema.medium14],
            for: .normal
        )
        deliveryTypeControl.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        deliveryTypeControl.backgroundColor = ApplicationDependency.manager.theme.colors.white
        deliveryTypeControl.selectedSegmentIndex = 0
    }

    private func setupConstraints() {
        moneyIndicatorLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                StoreDetailViewModel.UIStats.leadingSpace
            )
            make.bottom.equalToSuperview().offset(-16)
        }

        timeIndicatorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(moneyIndicatorLabel.snp.trailing).offset(6)
            make.bottom.equalTo(moneyIndicatorLabel)
        }

        distanceIndicatorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(timeIndicatorLabel.snp.trailing).offset(6)
            make.bottom.equalTo(moneyIndicatorLabel)
        }

        moneyValueLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(moneyIndicatorLabel.snp.top).offset(-2)
            make.leading.trailing.equalTo(moneyIndicatorLabel)
        }

        timeValueLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(moneyValueLabel)
            make.leading.equalTo(timeIndicatorLabel)
        }

        distanceValueLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(moneyValueLabel)
            make.leading.equalTo(distanceIndicatorLabel)
        }

        deliveryTypeControl.snp.makeConstraints { (make) in
            make.top.equalTo(moneyValueLabel)
            make.trailing.equalToSuperview().offset(
                -StoreDetailViewModel.UIStats.leadingSpace
            )
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }
}
