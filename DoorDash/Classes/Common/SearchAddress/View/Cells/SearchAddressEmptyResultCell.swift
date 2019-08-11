//
//  SearchAddressEmptyResultCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class SearchAddressEmptyResultCell: UICollectionViewCell {

    struct Constants {
        let labelFont: UIFont = ApplicationDependency.manager.theme.fonts.medium16
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 16
    }

    private let label: UILabel
    private let separator: Separator
    private let constants = Constants()

    override init(frame: CGRect) {
        label = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(text: String) {
        label.text = text
    }

    static func caclHeight(containerWidth: CGFloat, text: String) -> CGFloat {
        let constants = SearchAddressEmptyResultCell.Constants()
        let height = HelperManager.textHeight(text, width: containerWidth - constants.horizontalInset * 2, font: constants.labelFont)
        return height + constants.verticalInset * 2
    }
}

extension SearchAddressEmptyResultCell {

    private func setupUI() {
        setupLabel()
        setupSeparator()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(label)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = constants.labelFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = ApplicationDependency.manager.theme.colors.gray
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.6)
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(constants.horizontalInset)
            make.top.bottom.equalToSuperview().inset(constants.verticalInset)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
    }
}

