import UIKit

class NVActivityIndicatorAnimationBallClipRotate: NVActivityIndicatorAnimationDelegate {

    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 1.5
        // Rotate animation
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

        rotateAnimation.keyTimes = [0, 0.5, 1]
        rotateAnimation.values = [0, Double.pi, 2 * Double.pi]
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = CAMediaTimingFillMode.forwards

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [rotateAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards

        // Draw circle
        let circle = NVActivityIndicatorShape.ringThirdFour.layerWith(size: CGSize(width: size.width, height: size.height), color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                           y: (layer.bounds.size.height - size.height) / 2,
                           width: size.width,
                           height: size.height)

        circle.frame = frame
        circle.fillMode = .forwards
        circle.add(animation, forKey: "NVActivityIndicatorAnimationBallClipRotateAnimation")
        layer.addSublayer(circle)
        layer.fillMode = .forwards
    }
}
