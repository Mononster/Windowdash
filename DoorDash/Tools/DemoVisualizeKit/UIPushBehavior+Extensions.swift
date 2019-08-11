import UIKit

extension UIPushBehavior {

    static func shake(items: [UIDynamicItem], intensity: CGFloat) -> UIPushBehavior {
        let pushBehavior = UIPushBehavior(items: items, mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: intensity, dy: 0)
        return pushBehavior
    }
}
