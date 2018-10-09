//
//  ItemDetailAddInstructionsCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class ItemDetailAddInstructionsCell: UICollectionViewCell {

    private let addInstructionLabel: UILabel
    private let rightTriangleIndicator: UIImageView
    private let separator: Separator

    static let height: CGFloat = 60

    override init(frame: CGRect) {
        addInstructionLabel = UILabel()
        rightTriangleIndicator = UIImageView()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemDetailAddInstructionsCell {

    private func setupUI() {
        setupLabel()
        setupRightTriangleIndicator()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(addInstructionLabel)
        addInstructionLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        addInstructionLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
        addInstructionLabel.textAlignment = .left
        addInstructionLabel.adjustsFontSizeToFitWidth = true
        addInstructionLabel.minimumScaleFactor = 0.5
        addInstructionLabel.numberOfLines = 1
        addInstructionLabel.text = "Add Sepcial Instructions"
    }

    private func setupRightTriangleIndicator() {
        addSubview(rightTriangleIndicator)
        rightTriangleIndicator.image = ApplicationDependency.manager.theme.imageAssets.rightArrowImage
        rightTriangleIndicator.contentMode = .scaleAspectFit
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
    }

    private func setupConstraints() {
        addInstructionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightTriangleIndicator.snp.leading).offset(-8)
        }

        rightTriangleIndicator.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(rightTriangleIndicator.snp.width).multipliedBy(1.68)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalTo(addInstructionLabel)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
}
