//
//  StoreSortBinaryCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class StoreSortBinaryCell: StoreSortBaseCell {

    static func calcWidth(text: String) -> CGFloat {
        let constants = StoreSortBaseCell.Constants()
        let textWidth = HelperManager.textWidth(text, font: constants.titleLabelFont)
        return textWidth + 2 * constants.horizontalSpace
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalSeparator.isHidden = true
        dropDownButton.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
