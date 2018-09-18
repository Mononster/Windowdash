//
//  SubletStatusTitleCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class SubletStatusTitleCell: UICollectionViewCell {

    static let heightWithoutTitle: CGFloat = 25

    private let placeTypeLabel: UILabel
    private let titleLabel: UILabel

    var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
        }
    }

    var placeTypeText: String? {
        didSet {
            self.placeTypeLabel.text = placeTypeText
        }
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        placeTypeLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SubletStatusTitleCell {

    private func setupUI() {
        setupPlaceTypeLabel()
        setupTitleLabel()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 0
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium18
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(placeTypeLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(placeTypeLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }

    private func setupPlaceTypeLabel() {
        addSubview(placeTypeLabel)
        placeTypeLabel.backgroundColor = .clear
        placeTypeLabel.numberOfLines = 1
        placeTypeLabel.font = ApplicationDependency.manager.theme.fontSchema.medium18
        placeTypeLabel.textColor = ApplicationDependency.manager.theme.colors.black

        placeTypeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(25)
        }
    }
}

