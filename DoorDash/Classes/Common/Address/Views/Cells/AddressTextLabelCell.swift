//
//  AddressTextLabelCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class AddressTextLabelCell: UICollectionViewCell {

    private let titleLabel: UILabel
    let separator: Separator

    var text: String? {
        didSet {
            self.titleLabel.text = text
        }
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressTextLabelCell {

    private func setupUI() {
        setupTitleLabel()
        setupSeparator()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium15
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(18)
            make.top.bottom.trailing.equalToSuperview()
        }
    }

    private func setupSeparator() {
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray
        addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.height.equalTo(0.6)
            make.bottom.equalToSuperview()
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
}


