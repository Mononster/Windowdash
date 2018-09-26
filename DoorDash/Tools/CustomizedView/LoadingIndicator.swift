//
//  LoadingIndicator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

enum LoadingIndicatorStyle {
    case defaultActivityIndicator
    case nvActivityIndicator
}

final class LoadingIndicator: UIView {

    private let containerView: UIView
    private let defaultIndicatorView: UIActivityIndicatorView
    private let nvIndicatorView: NVActivityIndicatorView

    var style: LoadingIndicatorStyle?

    override init(frame: CGRect) {
        containerView = UIView()
        defaultIndicatorView = UIActivityIndicatorView()
        let viewSize: CGFloat = 60
        let loadingSize: CGFloat = 40
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

    func show(style: LoadingIndicatorStyle = .defaultActivityIndicator) {
        self.style = style
        self.superview?.bringSubviewToFront(self)
        self.isHidden = false
        self.alpha = 0
        switch style {
        case .defaultActivityIndicator:
            self.defaultIndicatorView.isHidden = false
            self.nvIndicatorView.isHidden = true
            self.nvIndicatorView.stopAnimating()
            self.defaultIndicatorView.startAnimating()
        case .nvActivityIndicator:
            self.nvIndicatorView.isHidden = false
            self.defaultIndicatorView.isHidden = true
            self.defaultIndicatorView.stopAnimating()
            self.nvIndicatorView.startAnimating()
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        })
    }

    func hide() {
        self.alpha = 1
        if let style = self.style {
            switch style {
            case .defaultActivityIndicator:
                self.defaultIndicatorView.stopAnimating()
            case .nvActivityIndicator:
                self.nvIndicatorView.stopAnimating()
            }
        }
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0
        }, completion: { finished in
            self.isHidden = true
        })
    }
}

extension LoadingIndicator {

    private func setupUI() {
        setupContainer()
        setupLoadingView()
        setupConstraints()
    }

    private func setupContainer() {
        self.addSubview(containerView)
        containerView.layer.cornerRadius = 6
        containerView.backgroundColor = ApplicationDependency.manager.theme.colors.loadingBackgroundColor
    }

    private func setupLoadingView() {
        containerView.addSubview(defaultIndicatorView)
        containerView.addSubview(nvIndicatorView)
        defaultIndicatorView.style = .whiteLarge
        defaultIndicatorView.color = ApplicationDependency.manager.theme.colors.darkGray
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        defaultIndicatorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
