//
//  UIFont+Size.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-24.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

extension UIFont {
    func sizeOfString (string: String, constrainedToSize size: CGSize) -> CGSize {
        return NSString(string: string).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: self],
            context: nil).size
    }
}
