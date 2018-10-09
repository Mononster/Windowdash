//
//  UIAnimators.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-09.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol UIAnimator {
    var defaultDuration: TimeInterval { get }
}

extension UIAnimator {
    var defaultDuration: TimeInterval { return 0.3 }
}

final class ShakeAnimator: UIAnimator {
    static let defaultShakeAnimKey = "shakeAnimation"

    func shake(viewToShake: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = defaultDuration
        animation.values = [-10.0, 10.0, -10.0, 10.0, -8.0, 8.0, -3.0, 3.0, 0.0 ]
        viewToShake.layer.add(animation, forKey: "shake")
    }
}
