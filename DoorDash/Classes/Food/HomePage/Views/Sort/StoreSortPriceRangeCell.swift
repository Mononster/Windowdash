//
//  StoreSortPriceRangeCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class StoreSortPriceRangeCell: StoreSortBaseCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func calcWidth(text: String) -> CGFloat {
        let constants = StoreSortBaseCell.Constants()
        let textWidth = HelperManager.textWidth(text, font: constants.titleLabelFont)
        return constants.horizontalSpace + textWidth + constants.spaceBetweenTitleLabelAndSeparator + constants.verticalSeparatorWidth + constants.spaceBetweenSeparatorAndImageView + constants.dropDownButtonWidth + constants.horizontalSpace
    }

    override func setupUI() {
        super.setupUI()
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(constants.horizontalSpace)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(verticalSeparator.snp.leading).offset(
                -constants.spaceBetweenTitleLabelAndSeparator
            )
        }
    }
}
