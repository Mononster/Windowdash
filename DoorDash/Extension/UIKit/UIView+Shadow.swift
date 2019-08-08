//
//  UIView+Shadow.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

extension UIView {

    var bottomSafePadding: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.bottom
        }
        return 0
    }
    
    public func addShadow(size: CGSize = CGSize(width: 0, height: 1),
                          radius: CGFloat = 20,
                          shadowColor: UIColor = .black,
                          shadowOpacity: Float = 0.36,
                          viewCornerRadius: CGFloat = 0) {
        layer.shadowOffset = size
        layer.shadowRadius = radius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius).cgPath
    }

    public func dropShadow(shadowColor: UIColor = UIColor.black,
                           fillColor: UIColor = UIColor.white,
                           opacity: Float = 0.2,
                           offset: CGSize = CGSize(width: 0.0, height: 1.0),
                           radius: CGFloat = 10) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
    }

    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
