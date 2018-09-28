//
//  UserAccountPageVersionCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class UserAccountPageVersionCell: UICollectionViewCell {

    private let versionLabel: UILabel
    static let height: CGFloat = 48

    override init(frame: CGRect) {
        self.versionLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(version: String) {
        self.versionLabel.text = version
    }
}

extension UserAccountPageVersionCell {

    private func setupUI() {
        setupVersionLabel()
        setupConstraints()
    }

    private func setupVersionLabel() {
        addSubview(versionLabel)
        versionLabel.textColor = ApplicationDependency.manager.theme.colors.lightGray
        versionLabel.font = ApplicationDependency.manager.theme.fontSchema.regular12
        versionLabel.textAlignment = .center
        versionLabel.adjustsFontSizeToFitWidth = true
        versionLabel.minimumScaleFactor = 0.5
        versionLabel.numberOfLines = 1
    }

    private func setupConstraints() {
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}




