//
//  LoadingIndicator.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class LoadingIndicator: UIView {

    private let containerView: UIView
    private let loadingView: UIActivityIndicatorView

    override init(frame: CGRect) {
        containerView = UIView()
        loadingView = UIActivityIndicatorView()
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
        self.loadingView.startAnimating()
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        })
    }

    func hide() {
        self.alpha = 1
        self.loadingView.startAnimating()
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
        containerView.addSubview(loadingView)
        loadingView.style = .whiteLarge
        loadingView.color = ApplicationDependency.manager.theme.colors.darkGray
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
