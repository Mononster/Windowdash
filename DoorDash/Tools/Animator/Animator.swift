//
//  Animator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

public protocol UIAnimator {
    var defaultDuration: TimeInterval { get }
}

public extension UIAnimator {
    var defaultDuration: TimeInterval { return 0.25 }
}

public class DefaultAnimator: UIAnimator {
    public static let duration: TimeInterval = 0.25
}

public final class UpdateConstraintsAnimator: UIAnimator {
    public func updateConstraints(containerView: UIView) {
        updateConstraints(containerView: containerView, completion: nil)
    }

    public func updateConstraints(containerView: UIView, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: defaultDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            containerView.layoutIfNeeded()
        }, completion: completion)
    }

    public func updateConstraints(containerView: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            containerView.layoutIfNeeded()
        }, completion: nil)
    }
}

public final class BounceAnimator: UIAnimator {
    public func bounce(containerView: UIView,
                       delay: Double = 0,
                       completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2,
                       delay: delay,
                       options: [.allowUserInteraction, .curveEaseOut],
                       animations: {
                        containerView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [.allowUserInteraction, .curveEaseIn],
                           animations: {
                            containerView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: completion)
        })
    }
}

public final class FadeInOutViewAnimator: UIAnimator {
    public static let defaultBorderWidthAnimKey = "defaultBorderWidthAnimKey"
    public func animateToDisplay(view: UIView,
                                 duration: TimeInterval,
                                 completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 1.0
        }) { finished in
            view.isHidden = false
            completion?(finished)
        }
    }

    public func animateToDismiss(view: UIView,
                                 duration: TimeInterval,
                                 completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0.0
        }) { finished in
            view.isHidden = true
            completion?(finished)
        }
    }

    public func fadeTransition(view: UIView, _ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        view.layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }

    public func fadeViewBorder(view: UIView,
                               from: CGFloat,
                               to: CGFloat,
                               duration: CFTimeInterval) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        view.layer.add(animation, forKey: FadeInOutViewAnimator.defaultBorderWidthAnimKey)
        view.layer.borderWidth = to
    }
}

public final class SlideMenuAnimator: UIAnimator {

    public func animateToDisplay(view: UIView,
                                 finalFrame: CGRect,
                                 duration: TimeInterval,
                                 completion: ((Bool) -> Void)?) {
        view.frame = CGRect(x: -finalFrame.width, y: 0, width: finalFrame.width, height: finalFrame.height)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            view.frame = finalFrame
        }) { finished in
            completion?(finished)
        }
    }

    public func animateToDismiss(view: UIView,
                                 duration: TimeInterval,
                                 completion: ((Bool) -> Void)?) {
        let currentFrame = view.frame
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            view.frame = CGRect(x: -currentFrame.width, y: 0, width: currentFrame.width, height: currentFrame.height)
        }) { finished in
            completion?(finished)
        }
    }
}

public final class ShakeAnimator: UIAnimator {
    public static let defaultShakeAnimKey = "shakeAnimation"

    public func shake(view: UIView) {
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-12.0, 12.0, -9.0, 9.0, -7.0, 7.0, -5.0, 5.0, -3.0, 3.0, 0.0].map {
            (degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }

        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [rotation]
        shakeGroup.duration = 0.8

        view.layer.add(shakeGroup, forKey: ShakeAnimator.defaultShakeAnimKey)
    }
}

public final class RotationAnimatior: UIAnimator {

    public static let defaultRotationKey = "rotationAnimation"

    public func animateRotation(view: UIView,
                                animationKey: String = RotationAnimatior.defaultRotationKey,
                                repeatCount: Float = .infinity,
                                delayForRound: TimeInterval = 0.2,
                                durationForRound: TimeInterval = 2.2) {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = durationForRound * 2 + delayForRound * 2
        animationGroup.repeatCount = repeatCount
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        let rotationPositive: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

        rotationPositive.fromValue = 0
        rotationPositive.toValue = Double.pi * 4
        rotationPositive.duration = durationForRound
        rotationPositive.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rotationPositive.autoreverses = false

        let rotationBack: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationBack.fromValue = Double.pi * 4
        rotationBack.toValue = 0
        rotationBack.duration = durationForRound
        rotationBack.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        rotationBack.autoreverses = false
        rotationBack.beginTime = durationForRound + delayForRound
        animationGroup.animations = [rotationPositive, rotationBack]
        view.layer.add(animationGroup, forKey: animationKey)
    }
}

public final class PopMessageAnimator: UIAnimator {

    public func animateForOpening(view: UIView,
                                  startingScale: CGFloat = 0.3,
                                  duration: TimeInterval = 0.7,
                                  completion: ((Bool) -> Void)? = nil){
        view.transform = CGAffineTransform(scaleX: startingScale, y: startingScale)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { finished in
            completion?(finished)
        })
    }

    public func animateForEnding(view: UIView,
                                 startingScale: CGFloat = 1,
                                 finalScale: CGFloat = 0.3,
                                 duration: TimeInterval = 0.7,
                                 completion: ((Bool) -> Void)? = nil){
        view.transform = CGAffineTransform(scaleX: startingScale, y: startingScale)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            view.transform = CGAffineTransform(scaleX: finalScale, y: finalScale)
        }, completion: { finished in
            completion?(finished)
        })
    }
}
