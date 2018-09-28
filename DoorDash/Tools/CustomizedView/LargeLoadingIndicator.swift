//
//  LargeLoadingIndicator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-22.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class LargeLoadingIndicator: UIView {

    private let containerView: UIView
    private let nvIndicatorView: NVActivityIndicatorView

    override init(frame: CGRect) {
        containerView = UIView()
        let viewSize: CGFloat = 80
        let loadingSize: CGFloat = 50
        let loadingViewFrame = CGRect(
            x: viewSize / 2 - loadingSize / 2,
            y: viewSize / 2 - loadingSize / 2,
            width: loadingSize,
            height: loadingSize
        )
        nvIndicatorView = NVActivityIndicatorView(
            frame: loadingViewFrame,
            type: .circleStrokeSpin,
            color: ApplicationDependency.manager.theme.colors.doorDashRed
        )
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        self.superview?.bringSubviewToFront(self)
        self.isHidden = false
        self.alpha = 0
        self.nvIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        })
    }

    func hide() {
        self.alpha = 1
            self.nvIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0
        }, completion: { finished in
            self.isHidden = true
        })
    }
}

extension LargeLoadingIndicator {

    private func setupUI() {
        setupContainer()
        setupLoadingView()
        setupConstraints()
    }

    private func setupContainer() {
        self.addSubview(containerView)
        containerView.layer.cornerRadius = 6
        containerView.backgroundColor = ApplicationDependency.manager.theme.colors.loadingBackgroundColor.withAlphaComponent(0.4)
    }

    private func setupLoadingView() {
        containerView.addSubview(nvIndicatorView)
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

