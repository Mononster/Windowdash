//
//  ItemDetailOverviewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class ItemDetailOverviewCell: UICollectionViewCell {

    private let itemNameLabel: UILabel
    private let itemDescriptionLabel: UILabel
    private let popularIndicatorLabel: UILabel
    let separator: Separator

    static let nameLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold30
    static let descriptionLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.medium16

    override init(frame: CGRect) {
        itemNameLabel = UILabel()
        itemDescriptionLabel = UILabel()
        popularIndicatorLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(itemName: String,
                   itemDescription: String?,
                   popularTag: String?) {
        self.itemNameLabel.text = itemName
        self.itemDescriptionLabel.text = itemDescription
        self.popularIndicatorLabel.text = popularTag
        self.popularIndicatorLabel.isHidden = popularTag == nil
        updateCellConstraints(showPopularTag: popularTag != nil)
    }

    private func updateCellConstraints(showPopularTag: Bool) {
        self.popularIndicatorLabel.snp.updateConstraints { (make) in
            let distance = showPopularTag ? 20 : 16
            make.top.equalToSuperview().offset(distance)
        }
    }
}

extension ItemDetailOverviewCell {

    private func setupUI() {
        setupPopularTagLabel()
        setupNameLabel()
        setupDescriptionLabel()
        setupSeparator()
        setupConstraints()
    }

    private func setupPopularTagLabel() {
        addSubview(popularIndicatorLabel)
        popularIndicatorLabel.isHidden = true
        popularIndicatorLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        popularIndicatorLabel.font = ApplicationDependency.manager.theme.fonts.extraBold14
        popularIndicatorLabel.textAlignment = .left
        popularIndicatorLabel.adjustsFontSizeToFitWidth = true
        popularIndicatorLabel.minimumScaleFactor = 0.5
        popularIndicatorLabel.numberOfLines = 1
    }

    private func setupNameLabel() {
        addSubview(itemNameLabel)
        itemNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        itemNameLabel.font = ItemDetailOverviewCell.nameLabelFont
        itemNameLabel.textAlignment = .left
        itemNameLabel.adjustsFontSizeToFitWidth = true
        itemNameLabel.minimumScaleFactor = 0.5
        itemNameLabel.numberOfLines = 0
    }

    private func setupDescriptionLabel() {
        addSubview(itemDescriptionLabel)
        itemDescriptionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        itemDescriptionLabel.font = ItemDetailOverviewCell.descriptionLabelFont
        itemDescriptionLabel.textAlignment = .left
        itemDescriptionLabel.adjustsFontSizeToFitWidth = true
        itemDescriptionLabel.minimumScaleFactor = 0.5
        itemDescriptionLabel.numberOfLines = 0
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
    }

    private func setupConstraints() {
        popularIndicatorLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(
                ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue
            )
        }

        itemNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(popularIndicatorLabel.snp.bottom)
            make.leading.trailing.equalTo(popularIndicatorLabel)
        }

        itemDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(popularIndicatorLabel)
        }

        separator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalTo(popularIndicatorLabel)
            make.height.equalTo(0.6)
        }
    }
}
