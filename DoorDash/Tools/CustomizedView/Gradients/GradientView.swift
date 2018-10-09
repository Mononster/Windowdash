//
//  GradientView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import QuartzCore

final class GradientView: UIView {

    var gradientLayer: CAGradientLayer!

    var gradientBackgroundColor: UIColor? {
        didSet {
            updateGradient()
        }
    }

    func updateGradient() {
        let color = gradientBackgroundColor ?? UIColor.white
        let white = color.withAlphaComponent(1.0).cgColor
        let clear = color.withAlphaComponent(0.0).cgColor
        gradientLayer.colors = [clear, white]
    }

    func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        updateGradient()
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupGradientLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupGradientLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame  = self.bounds
        gradientLayer.setNeedsDisplay()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

