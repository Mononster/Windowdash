//
//  CheckMarkActivityView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class PaymentActivityView: UIView {
    private let circleLayer: CAShapeLayer
    private let checkMarkLayer: CAShapeLayer
    private let placeHolderLayer: CAShapeLayer
    private let layerSize = CGSize(width: 60, height: 60)

    override init(frame: CGRect) {
        circleLayer = CAShapeLayer()
        checkMarkLayer = CAShapeLayer()
        placeHolderLayer = CAShapeLayer()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimation() {
        self.layer.sublayers?.removeAll()
        self.layer.addSublayer(placeHolderLayer)
        self.layer.addSublayer(circleLayer)
        let duration: CFTimeInterval = 1.5
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.byValue = 2 * Double.pi
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = HUGE
        circleLayer.add(rotateAnimation, forKey: "rotationAnim")
    }

    func showSuccess() {
        self.layer.addSublayer(checkMarkLayer)
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = 0.5
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.fillMode = .forwards
        checkMarkLayer.add(strokeAnimation, forKey: "checkMarkStrokeAnim")
    }

    func showFailure() {

    }

    func updateState(success: Bool) {
        let transform = circleLayer.presentation()!.transform
        circleLayer.removeAllAnimations()
        circleLayer.transform = transform

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeEndAnimation.duration = 0.5
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.fillMode = .forwards
        circleLayer.add(strokeEndAnimation, forKey: "strokeAnim")

        if success {
            showSuccess()
        } else {
            showFailure()
        }
    }
}

extension PaymentActivityView {

    private func setupUI() {
        self.backgroundColor = .clear
        setupLayers()
    }

    private func setupLayers() {
        setupCheckMarkLayer()
        setupPlaceHolderOval()
        setupCircleLayer()
    }

    private func setupCheckMarkLayer() {
        let checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: 19, y: 30.32))
        checkMarkPath.addLine(to: CGPoint(x: 28.52, y: 38))
        checkMarkPath.addLine(to: CGPoint(x: 42, y: 22))
        checkMarkLayer.path = checkMarkPath.cgPath
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.strokeColor = UIColor.white.cgColor
        checkMarkLayer.lineWidth = 3
        checkMarkLayer.lineCap = .round
        checkMarkLayer.lineJoin = .round
    }

    private func setupPlaceHolderOval() {
        let frame = CGRect(x: (layer.bounds.size.width - layerSize.width) / 2,
                           y: (layer.bounds.size.height - layerSize.height) / 2,
                           width: layerSize.width,
                           height: layerSize.height)
        let ovalPath = UIBezierPath(ovalIn: frame)
        placeHolderLayer.path = ovalPath.cgPath
        placeHolderLayer.fillColor = UIColor.clear.cgColor
        placeHolderLayer.strokeColor = UIColor.white.cgColor
        placeHolderLayer.lineWidth = 3
        placeHolderLayer.backgroundColor = UIColor.clear.cgColor
        placeHolderLayer.lineJoin = .round
        placeHolderLayer.lineCap = .round
    }

    private func setupCircleLayer() {
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: layerSize.width / 2, y: layerSize.height / 2),
                    radius: layerSize.width / 2,
                    startAngle: CGFloat(Double.pi / 4),
                    endAngle: CGFloat(-Double.pi / 4),
                    clockwise: false)
        circleLayer.transform = CATransform3DIdentity
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.lineWidth = 3.5
        circleLayer.backgroundColor = UIColor.clear.cgColor
        circleLayer.path = path.cgPath
        let frame = CGRect(x: (layer.bounds.size.width - layerSize.width) / 2,
                           y: (layer.bounds.size.height - layerSize.height) / 2,
                           width: layerSize.width,
                           height: layerSize.height)
        circleLayer.frame = frame
    }
}
