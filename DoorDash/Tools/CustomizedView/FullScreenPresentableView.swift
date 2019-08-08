//
//  FullScreenPresentableView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/5/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import SnapKit

class FullScreenPresentableView: UIView {

    let backgroundView: UIView
    let theme = ApplicationDependency.manager.theme

    override public init(frame: CGRect) {
        backgroundView = UIView()
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func show() {
        if self.superview != nil {
            return
        }
        // Find current top viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self.backgroundView)
            superView.addSubview(self)
            superView.endEditing(true)
            self.configureConstraints(superView)
            self.animateForOpening()
        }
    }

    open func animateForOpening() {
        self.superview?.bringSubviewToFront(self)
        self.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.backgroundView.alpha = 0.5
        })
    }

    open func hide(duration: TimeInterval = 0.15, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.backgroundView.alpha = 0
        }, completion: { finished in
            self.isHidden = true
            self.cleanViews()
            completion?()
        })
    }

    open func cleanViews() {
        self.backgroundView.removeFromSuperview()
        self.removeFromSuperview()
    }

    open func setupUI() {
        setupContainer()
    }

    private func setupContainer() {
        backgroundView.alpha = 0
        backgroundView.backgroundColor = ApplicationDependency.manager.theme.colors.black
    }

    open func configureConstraints(_ superView: UIView) {
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.superview?.layoutIfNeeded()
    }

    private func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
