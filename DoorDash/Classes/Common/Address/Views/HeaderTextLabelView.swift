//
//  HeaderTextLabelView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class HeaderTextLabelView: UIView {

    private let titleLabel: UILabel
    static let height: CGFloat = 80

    init(text: String) {
        titleLabel = UILabel()
        titleLabel.text = text
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderTextLabelView {

    private func setupUI() {
        setupTitleLabel()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.regular15
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black.withAlphaComponent(0.8)

        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}


