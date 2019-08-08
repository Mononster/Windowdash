//
//  UILabel+NumOfLines.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

extension UILabel {

    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? ApplicationDependency.manager.theme.fonts.medium16], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
