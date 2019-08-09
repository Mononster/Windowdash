//
//  RedoSearchButton.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class RedoSearchButton: UIButton {

    struct Constants {
        let loadingSize: CGFloat = 25
        let loadingContainerSize: CGFloat = 40
    }

    private let loadingIndictor: NVActivityIndicatorView

    private var cachedTitle: String?

    private let shrinkCurve: CAMediaTimingFunction = .init(name: .linear)
    private let shrinkDuration: CFTimeInterval = 0.1

    override init(frame: CGRect) {
        let constants = RedoSearchButton.Constants()
        let loadingViewFrame = CGRect(
            x: (constants.loadingContainerSize - constants.loadingSize) / 2,
            y: (constants.loadingContainerSize - constants.loadingSize) / 2,
            width: constants.loadingSize,
            height: constants.loadingSize
        )
        loadingIndictor = NVActivityIndicatorView(
            frame: loadingViewFrame,
            type: .circleStrokeSpin,
            color: ApplicationDependency.manager.theme.colors.doorDashRed,
            lineWidth: 1.8
        )
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setup() {
    }

    func prepareToAnimate() {
        isUserInteractionEnabled = false
        cachedTitle = title(for: .normal)
        setTitle("",  for: .normal)
        setImage(nil, for: .normal)
    }

    func startAnimation() {
        addSubview(loadingIndictor)
        loadingIndictor.startAnimating()

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [2, -2, -2, 2, 0.0]
        layer.add(animation, forKey: "shake")
    }

    func stopAnimation() {
        loadingIndictor.stopAnimating()
        loadingIndictor.removeFromSuperview()
    }

    func setOriginalState() {
        setTitle(cachedTitle, for: .normal)
        isUserInteractionEnabled = true
    }
}
