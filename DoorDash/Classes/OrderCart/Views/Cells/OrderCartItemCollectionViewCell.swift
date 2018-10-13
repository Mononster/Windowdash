//
//  OrderCartItemCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import SwipeCellKit

final class OrderCartItemCollectionViewCell: SwipeCollectionViewCell {

    static let height: CGFloat = 70

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray

        let label = UILabel()
        label.textColor = UIColor.blue
        label.text = "Text"
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
