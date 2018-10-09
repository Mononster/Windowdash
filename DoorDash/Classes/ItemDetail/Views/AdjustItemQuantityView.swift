//
//  AdjustItemQuantityView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class AdjustItemQuantityView: UIView {

    private let minusButton: UIButton
    private let displayLabel: UILabel
    private let addButton: UIButton

    static let width: CGFloat = 170
    static let height: CGFloat = 60

    var addButtonTapped: (() -> ())?
    var minusButtonTapped: (() -> ())?

    override init(frame: CGRect) {
        minusButton = UIButton()
        displayLabel = UILabel()
        addButton = UIButton()
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(numberOfItems: String,
                   isMinusButtonDisabled: Bool,
                   isAddButtonDisabled: Bool) {
        self.displayLabel.text = numberOfItems
        self.minusButton.isEnabled = !isMinusButtonDisabled
        self.addButton.isEnabled = !isAddButtonDisabled

        self.minusButton.setImage(isMinusButtonDisabled ?
            ApplicationDependency.manager.theme.imageAssets.minusItemUnselecetedIcon :
            ApplicationDependency.manager.theme.imageAssets.minusItemIcon, for: .normal)
        self.addButton.setImage(isAddButtonDisabled ?
            ApplicationDependency.manager.theme.imageAssets.addItemUnselectedIcon :
            ApplicationDependency.manager.theme.imageAssets.addItemIcon, for: .normal)
    }

    @objc
    func userTappedMinusButton() {
        self.minusButtonTapped?()
    }

    @objc
    func userTappedAddButton() {
        self.addButtonTapped?()
    }

    private func setupActions() {
        self.minusButton.addTarget(self, action: #selector(userTappedMinusButton), for: .touchUpInside)
        self.addButton.addTarget(self, action: #selector(userTappedAddButton), for: .touchUpInside)
    }
}

extension AdjustItemQuantityView {

    private func setupUI() {
        setupLabel()
        setupButtons()
        setupConstraints()
        self.layer.borderWidth = 1.5
        self.layer.borderColor = ApplicationDependency.manager.theme.colors.adjustQuantityBorder.cgColor
        self.layer.cornerRadius = AdjustItemQuantityView.height / 2
        self.layer.masksToBounds = true
    }

    private func setupLabel() {
        addSubview(displayLabel)
        displayLabel.textColor = ApplicationDependency.manager.theme.colors.black
        displayLabel.font = ApplicationDependency.manager.theme.fontSchema.bold18
        displayLabel.textAlignment = .center
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.minimumScaleFactor = 0.5
        displayLabel.numberOfLines = 1
    }

    private func setupButtons() {
        addSubview(minusButton)
        minusButton.contentMode = .center
        minusButton.setImage(ApplicationDependency.manager.theme.imageAssets.minusItemIcon, for: .normal)
        minusButton.backgroundColor = .clear

        addSubview(addButton)
        addButton.contentMode = .center
        addButton.setImage(ApplicationDependency.manager.theme.imageAssets.addItemIcon, for: .normal)
        addButton.backgroundColor = .clear
    }

    private func setupConstraints() {
        minusButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        displayLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(minusButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading).offset(-8)
        }

        addButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
}
