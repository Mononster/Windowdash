//
//  StoreDetailMenuSeparatorCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreDetailMenuSeparatorCell: UICollectionViewCell {

    static let height: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoreDetailMenuSeparatorCell {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.4)
    }
}
