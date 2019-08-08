//
//  CollectionFilterItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/5/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class CollectionFilterItemCell: UICollectionViewCell {

    struct Constants {
        let size: CGFloat = 60
        let textFont: UIFont = ApplicationDependency.manager.theme.fonts.medium14
        let containerNormalColor: UIColor = ApplicationDependency.manager.theme.colors.separatorGray
        let containerSelectedColor: UIColor = ApplicationDependency.manager.theme.colors.doorDashDarkRed
    }

    private let titleLabel: UILabel
    private let container: UIView

    private let theme = ApplicationDependency.manager.theme
    private let constants = Constants()

    override init(frame: CGRect) {
        titleLabel = UILabel()
        container = UIView()
        super.init(frame: frame)
        setupUI()
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
        titleLabel.textColor = constants.containerSelectedColor
    }

    func setNormalCellState() {
        container.layer.borderColor = constants.containerNormalColor.cgColor
        container.backgroundColor = theme.colors.white
        titleLabel.textColor = constants.containerNormalColor.withAlphaComponent(0.9)
    }
}

extension CollectionFilterItemCell {

    private func setupUI() {
        setupContainer()
        setupTagLabel()
        setupConstraints()
    }

    private func setupContainer() {
        addSubview(container)
        container.backgroundColor = .clear
        container.layer.cornerRadius = constants.size / 2
        container.layer.borderWidth = 2
    }

    private func setupTagLabel() {
        container.addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = theme.colors.white
        titleLabel.font = constants.textFont
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(4)
        }
    }
}
