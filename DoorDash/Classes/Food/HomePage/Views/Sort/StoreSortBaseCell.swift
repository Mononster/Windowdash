//
//  StoreSortBaseCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class StoreSortBaseCell: UICollectionViewCell {

    struct Constants {
        let containerHeight: CGFloat = 38
        let containerNormalColor: UIColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.8)
        let containerSelectedColor: UIColor = ApplicationDependency.manager.theme.colors.doorDashDarkRed
        let titleLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.medium14
        let horizontalSpace: CGFloat = 12
        let dropDownButtonHeight: CGFloat = 10 + 6 + 6
        let dropDownButtonWidth: CGFloat = 10 + 2 + 2
        let starImageViewSize: CGFloat = 12
        let spaceBetweenSeparatorAndImageView: CGFloat = 6
        let spaceBetweenStarAndTitleLabel: CGFloat = 4
        let spaceBetweenTitleLabelAndSeparator: CGFloat = 8
        let verticalSeparatorWidth: CGFloat = 1
    }

    let container: UIView
    let titleLabel: UILabel
    let verticalSeparator: Separator
    let dropDownButton: UIButton

    let theme = ApplicationDependency.manager.theme
    var dropDownButtonTapped: (() -> ())?
    let constants = Constants()

    override init(frame: CGRect) {
        container = UIView()
        titleLabel = UILabel()
        verticalSeparator = Separator.create()
        dropDownButton = UIButton()
        super.init(frame: frame)
        setupUI()
        dropDownButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedDropDownButton))
        dropDownButton.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String, selected: Bool) {
        selected ? setSelectedCellState() : setNormalCellState()
        titleLabel.text = title
    }

    func setSelectedCellState() {
        container.layer.borderColor = constants.containerSelectedColor.cgColor
        container.backgroundColor = constants.containerSelectedColor.withAlphaComponent(0.1)
        verticalSeparator.backgroundColor = constants.containerSelectedColor
        dropDownButton.imageView?.setImageColor(color: constants.containerSelectedColor)
        titleLabel.textColor = constants.containerSelectedColor
    }

    func setNormalCellState() {
        container.layer.borderColor = constants.containerNormalColor.cgColor
        container.backgroundColor = theme.colors.white
        verticalSeparator.backgroundColor = constants.containerNormalColor
        dropDownButton.imageView?.setImageColor(color: theme.colors.black)
        titleLabel.textColor = theme.colors.black
    }

    func setupUI() {
        setupContainer()
        setupTitleLabel()
        setupVerticalSeparator()
        setupDropDownImageView()
        setupConstraints()
    }

    func setupContainer() {
        addSubview(container)
        container.layer.cornerRadius = constants.containerHeight / 2
        container.layer.borderWidth = 1
    }

    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = constants.titleLabelFont
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    func setupVerticalSeparator() {
        container.addSubview(verticalSeparator)
    }

    func setupDropDownImageView() {
        container.addSubview(dropDownButton)
        dropDownButton.setImage(theme.imageAssets.dropDownIndicator, for: .normal)
        dropDownButton.contentVerticalAlignment = .center
        dropDownButton.contentHorizontalAlignment = .center
        dropDownButton.imageView?.contentMode = .scaleAspectFit
        dropDownButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2)
    }

    func setupConstraints() {
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        dropDownButton.snp.makeConstraints { (make) in
            make.width.equalTo(constants.dropDownButtonWidth)
            make.height.equalTo(constants.dropDownButtonHeight)
            make.centerY.equalToSuperview()
        }

        verticalSeparator.snp.makeConstraints { (make) in
            make.trailing.equalTo(dropDownButton.snp.leading).offset(
                -constants.spaceBetweenSeparatorAndImageView
            )
            make.width.equalTo(constants.verticalSeparatorWidth)
            make.top.bottom.equalToSuperview().inset(8)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(constants.horizontalSpace)
        }
    }
}

extension StoreSortBaseCell {

    @objc
    private func tappedDropDownButton() {
        self.dropDownButtonTapped?()
    }
}
