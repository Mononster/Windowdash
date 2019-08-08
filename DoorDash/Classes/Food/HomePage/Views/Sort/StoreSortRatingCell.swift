//
//  StoreSortRatingCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class StoreSortRatingCell: StoreSortBaseCell {

    private let starImageView: UIImageView

    override init(frame: CGRect) {
        starImageView = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func calcWidth(text: String) -> CGFloat {
        let constants = StoreSortBaseCell.Constants()
        let textWidth = HelperManager.textWidth(text, font: constants.titleLabelFont)
        return constants.horizontalSpace + textWidth + constants.spaceBetweenStarAndTitleLabel + constants.starImageViewSize + constants.spaceBetweenSeparatorAndImageView + constants.verticalSeparatorWidth + constants.spaceBetweenSeparatorAndImageView + constants.dropDownButtonWidth + constants.horizontalSpace
    }

    override func setupCell(title: String, selected: Bool) {
        super.setupCell(title: title, selected: selected)
        starImageView.setImageColor(color: selected ? constants.containerSelectedColor : theme.colors.black)
    }

    override func setupUI() {
        super.setupUI()
        setupStarImageView()
        starImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(verticalSeparator.snp.leading).offset(
                -constants.spaceBetweenSeparatorAndImageView
            )
            make.size.equalTo(constants.starImageViewSize)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(constants.horizontalSpace)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(starImageView.snp.leading).offset(
                -constants.spaceBetweenStarAndTitleLabel
            )
        }
    }

    private func setupStarImageView() {
        container.addSubview(starImageView)
        starImageView.image = theme.imageAssets.ratingStarFull
        starImageView.contentMode = .scaleAspectFit
    }
}

