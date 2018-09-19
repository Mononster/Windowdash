//
//  UIView+Border.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

extension UIView {
    public struct Border: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let top = Border(rawValue: 1<<0)
        public static let right = Border(rawValue: 1<<1)
        public static let bottom = Border(rawValue: 1<<2)
        public static let left = Border(rawValue: 1<<3)

        public static let all: Border = [ .top, .right, .bottom, .left ]
    }

    public func setBorder(_ border: Border, color: UIColor, borderWidth: CGFloat) {
        if border == .all {
            layer.borderWidth = borderWidth
            layer.borderColor = color.cgColor
            return
        }

        if border.contains(.top) {
            let topBorderLayer = CALayer()
            topBorderLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: borderWidth)
            topBorderLayer.backgroundColor = color.cgColor
            layer.addSublayer(topBorderLayer)
        }

        if border.contains(.right) {
            let rightBorderLayer = CALayer()
            rightBorderLayer.frame = CGRect(x: bounds.width - borderWidth, y: 0, width: borderWidth, height: bounds.height)
            rightBorderLayer.backgroundColor = color.cgColor
            layer.addSublayer(rightBorderLayer)
        }

        if border.contains(.bottom) {
            let bottomBorderLayer = CALayer()
            bottomBorderLayer.frame = CGRect(x: 0, y: bounds.height - borderWidth, width: bounds.width, height: borderWidth)
            bottomBorderLayer.backgroundColor = color.cgColor
            layer.addSublayer(bottomBorderLayer)
        }

        if border.contains(.left) {
            let leftBorderLayer = CALayer()
            leftBorderLayer.frame = CGRect(x: 0, y: 0, width: borderWidth, height: bounds.height)
            leftBorderLayer.backgroundColor = color.cgColor
            layer.addSublayer(leftBorderLayer)
        }
    }
}

