//
//  DoordashTextField.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

public class DoordashTextField: UITextField {

    private let leftEdge: CGFloat

    public init(leftEdge: CGFloat = 10) {
        self.leftEdge = leftEdge
        super.init(frame: CGRect.zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftEdge, bottom: 0, right: leftEdge))
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftEdge, bottom: 0, right: leftEdge))
    }
}
