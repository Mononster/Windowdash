//
//  BrowseFoodSectionHeaderViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class BrowseFoodSectionHeaderViewCell: UICollectionViewCell {

    struct Constants {
        let verticalSpace: CGFloat = 16
        let titleLabelLeadingSpace: CGFloat = BrowseFoodViewModel.UIConfigure.homePageLeadingSpace - 2
        let titleLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold20
        let seeAllButtonWidth: CGFloat = 80
        let seeAllButtonHeight: CGFloat = 32
        let distanceBetweenTitleAndButton: CGFloat = 16
    }

    private let titleLabel: UILabel
    private let separator: Separator
    private let seeAllButton: UIButton

    var seeAllButtonTapped: (() -> Void)?

    private let constants = Constants()

    override init(frame: CGRect) {
        titleLabel = UILabel()
        separator = Separator.create()
        seeAllButton = UIButton()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String) {
        titleLabel.text = title
    }

    static func calcHeight(containerWidth: CGFloat,
                           title: String) -> CGFloat {
        let constants = BrowseFoodSectionHeaderViewCell.Constants()
        let titleLabelWidth = containerWidth - 2 * constants.titleLabelLeadingSpace - constants.seeAllButtonWidth - constants.distanceBetweenTitleAndButton
        let titleHeight: CGFloat = HelperManager.textHeight(title, width: titleLabelWidth, font: constants.titleLabelFont)
        return constants.verticalSpace + titleHeight + constants.verticalSpace + 4
    }
}

extension BrowseFoodSectionHeaderViewCell {

    private func setupUI() {
        setupLabel()
        setupSeeAllButton()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = constants.titleLabelFont
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 0
    }

    private func setupSeeAllButton() {
        addSubview(seeAllButton)
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        seeAllButton.titleLabel?.font = ApplicationDependency.manager.theme.fonts.medium16
        seeAllButton.setTitleColor(ApplicationDependency.manager.theme.colors.doorDashRed, for: .normal)
        seeAllButton.backgroundColor = .clear
        seeAllButton.contentHorizontalAlignment = .right
        seeAllButton.titleLabel?.contentMode = .right
        seeAllButton.addTarget(self, action: #selector(tappedSeeAllButton), for: .touchUpInside)
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.layer.cornerRadius = 2
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(constants.verticalSpace)
            make.trailing.equalTo(seeAllButton.snp.leading).offset(
                -constants.distanceBetweenTitleAndButton
            )
            make.leading.equalToSuperview().offset(constants.titleLabelLeadingSpace)
        }

        seeAllButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-constants.titleLabelLeadingSpace)
            make.centerY.equalToSuperview()
            make.width.equalTo(constants.seeAllButtonWidth)
            make.height.equalTo(constants.seeAllButtonHeight)
        }

        separator.snp.makeConstraints { (make) in
            make.height.equalTo(4)
            make.width.equalTo(35)
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}

extension BrowseFoodSectionHeaderViewCell {

    @objc
    private func tappedSeeAllButton() {
        seeAllButtonTapped?()
    }
}
