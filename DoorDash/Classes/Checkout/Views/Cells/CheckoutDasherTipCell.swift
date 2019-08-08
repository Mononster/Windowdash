//
//  CheckoutDasherTipCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class CheckoutDasherTipCell: UICollectionViewCell {

    private let dasherTipTitleLabel: UILabel
    private let dasherTipValueLabel: UILabel
    private let selectTipSegmentView: UISegmentedControl
    private let tipGoToDasherHints: UILabel

    static let height: CGFloat = 4 + 20 + 16 + 30 + 4 + 20

    var segmentControlChangedIndex: ((Int) -> ())?

    override init(frame: CGRect) {
        dasherTipTitleLabel = UILabel()
        dasherTipValueLabel = UILabel()
        selectTipSegmentView = UISegmentedControl(items: [])
        tipGoToDasherHints = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(exactTipValue: String,
                   tipValues: [String],
                   selectedIndex: Int) {
        self.selectTipSegmentView.removeAllSegments()
        self.dasherTipTitleLabel.text = "Dasher Tip"
        self.tipGoToDasherHints.text = "100% goes to your dasher"
        for (i, tip) in tipValues.enumerated() {
            self.selectTipSegmentView.insertSegment(withTitle: tip, at: i, animated: false)
        }
        self.selectTipSegmentView.insertSegment(withTitle: "Others", at: tipValues.count, animated: false)
        self.selectTipSegmentView.selectedSegmentIndex = selectedIndex
        self.dasherTipValueLabel.text = exactTipValue
    }
}

extension CheckoutDasherTipCell {

    @objc
    private func toggleSwithed(_ segmentedControl: UISegmentedControl) {
        self.segmentControlChangedIndex?(segmentedControl.selectedSegmentIndex)
    }
}

extension CheckoutDasherTipCell {

    private func setupUI() {
        setupLabels()
        setupSegmentedControl()
        setupConstraints()
    }

    private func setupLabels() {
        setupDasherTipTitleLabel()
        setupDasherTipValueLabel()
        setupDasherTipHintsLabel()
    }

    private func setupDasherTipTitleLabel() {
        addSubview(dasherTipTitleLabel)
        dasherTipTitleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        dasherTipTitleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        dasherTipTitleLabel.textAlignment = .left
        dasherTipTitleLabel.adjustsFontSizeToFitWidth = true
        dasherTipTitleLabel.minimumScaleFactor = 0.5
        dasherTipTitleLabel.numberOfLines = 1
    }

    private func setupDasherTipValueLabel() {
        addSubview(dasherTipValueLabel)
        dasherTipValueLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        dasherTipValueLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        dasherTipValueLabel.textAlignment = .right
        dasherTipValueLabel.adjustsFontSizeToFitWidth = true
        dasherTipValueLabel.minimumScaleFactor = 0.5
        dasherTipValueLabel.numberOfLines = 1
    }

    private func setupDasherTipHintsLabel() {
        addSubview(tipGoToDasherHints)
        tipGoToDasherHints.textColor = ApplicationDependency.manager.theme.colors.darkGray
        tipGoToDasherHints.font = ApplicationDependency.manager.theme.fonts.medium12
        tipGoToDasherHints.textAlignment = .left
        tipGoToDasherHints.adjustsFontSizeToFitWidth = true
        tipGoToDasherHints.minimumScaleFactor = 0.5
        tipGoToDasherHints.numberOfLines = 1
    }

    private func setupSegmentedControl() {
        addSubview(selectTipSegmentView)
        selectTipSegmentView.setTitleTextAttributes(
            [NSAttributedString.Key.font: ApplicationDependency.manager.theme.fonts.medium16], for: .normal
        )
        selectTipSegmentView.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        selectTipSegmentView.backgroundColor = ApplicationDependency.manager.theme.colors.white
        selectTipSegmentView.addTarget(self, action: #selector(toggleSwithed(_:)), for: .valueChanged)
    }

    private func setupConstraints() {
        dasherTipTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(CheckoutViewModel.UIStats.leadingSpace.rawValue + 4)
            make.top.equalToSuperview().offset(4)
        }

        dasherTipValueLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalTo(dasherTipTitleLabel)
        }

        selectTipSegmentView.snp.makeConstraints { (make) in
            make.top.equalTo(dasherTipTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(dasherTipTitleLabel)
            make.trailing.equalTo(dasherTipValueLabel)
            make.height.equalTo(30)
        }

        tipGoToDasherHints.snp.makeConstraints { (make) in
            make.top.equalTo(selectTipSegmentView.snp.bottom).offset(4)
            make.leading.equalTo(selectTipSegmentView)
        }
    }
}
