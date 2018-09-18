//
//  Separator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class Separator: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    static func create() -> Separator {
        let separator = Separator()
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray
        return separator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
