//
//  ItemDetailOptionCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class ItemDetailOptionCell: UICollectionViewCell {

    var cellTapped: ((_ isSelected: Bool) -> ())?

    private let singleSelectionButton: LTHRadioButton
    private let multiSelectionButton: MultiSelectionButton
    private let optionNameLabel: UILabel
    private let priceLabel: UILabel
    private let separator: Separator
    private var selectionMode: MenuItemExtraSelectionMode = .singleSelect
    var cellSelected: Bool = false

    static let height: CGFloat = 60

    override init(frame: CGRect) {
        singleSelectionButton = LTHRadioButton(style: .circle, diameter: 20)
        multiSelectionButton = MultiSelectionButton()
        optionNameLabel = UILabel()
        priceLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(mode: MenuItemExtraSelectionMode,
                   optionName: String,
                   price: String?,
                   selected: Bool) {
        self.multiSelectionButton.isHidden = mode == .singleSelect
        self.singleSelectionButton.isHidden = mode == .multiSelect
        self.optionNameLabel.text = optionName
        self.priceLabel.text = price
        self.priceLabel.isHidden = price == nil
        self.selectionMode = mode
        self.updateCell(selected: selected)
    }

    func updateCell(selected: Bool) {
        self.cellSelected = selected
        self.optionNameLabel.textColor = selected ?
            ApplicationDependency.manager.theme.colors.doorDashRed :
            ApplicationDependency.manager.theme.colors.black
        self.priceLabel.textColor = selected ?
            ApplicationDependency.manager.theme.colors.doorDashRed :
            ApplicationDependency.manager.theme.colors.doorDashDarkGray
        self.multiSelectionButton.toggleCheckmark(selected: selected)
        self.singleSelectionButton.setStateWithoutAction(isSelected: selected)
    }

    private func setupActions() {
        singleSelectionButton.onSelect {
            self.cellTapped?(true)
        }
        singleSelectionButton.onDeselect {
            if self.selectionMode == .multiSelect {
                self.cellTapped?(false)
            }
        }
        multiSelectionButton.addTarget(self, action: #selector(userTapped), for: .touchUpInside)
    }

    func presentInvalidSeletion() {
        let animator = ShakeAnimator()
        animator.shake(view: self)
    }

    @objc
    func userTapped() {
        self.cellTapped?(isSelected)
    }
}

extension ItemDetailOptionCell {

    private func setupUI() {
        setupLabels()
        setupSelectionButtons()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabels() {
        addSubview(optionNameLabel)
        optionNameLabel.textColor = ApplicationDependency.manager.theme.colors.black
        optionNameLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        optionNameLabel.textAlignment = .left
        optionNameLabel.adjustsFontSizeToFitWidth = true
        optionNameLabel.minimumScaleFactor = 0.5
        optionNameLabel.numberOfLines = 1

        addSubview(priceLabel)
        priceLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        priceLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        priceLabel.textAlignment = .right
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.numberOfLines = 1
    }

    private func setupSelectionButtons() {
        addSubview(singleSelectionButton)
        singleSelectionButton.selectedColor = ApplicationDependency.manager.theme.colors.doorDashRed
        singleSelectionButton.deselectedColor = ApplicationDependency.manager.theme.colors.separatorGray
        addSubview(multiSelectionButton)
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
    }

    private func setupConstraints() {
        singleSelectionButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue + 4
            )
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        multiSelectionButton.snp.makeConstraints { (make) in
            make.edges.equalTo(singleSelectionButton)
        }

        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-ItemDetailInfoViewModel.UIStats.leadingSpace.rawValue)
        }

        optionNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(singleSelectionButton.snp.trailing).offset(16)
            make.centerY.equalTo(singleSelectionButton).offset(-1)
            make.trailing.equalTo(priceLabel.snp.leading)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalTo(optionNameLabel)
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
}
