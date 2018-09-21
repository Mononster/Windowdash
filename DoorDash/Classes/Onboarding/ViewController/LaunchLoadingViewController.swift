//
//  LaunchLoadingViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class LaunchLoadingViewController: BaseViewController {

    private let circleStokeLoadingView: NVActivityIndicatorView
    private let logoImageView: UIImageView

    override init() {
        let loadingSize: CGFloat = 40
        let loadingViewFrame = CGRect(
            x: UIScreen.main.bounds.width / 2 - loadingSize / 2,
            y: UIScreen.main.bounds.height / 2 + 100,
            width: loadingSize,
            height: loadingSize
        )
        circleStokeLoadingView = NVActivityIndicatorView(
            frame: loadingViewFrame,
            type: .circleStrokeSpin,
            color: ApplicationDependency.manager.theme.colors.doorDashRed
        )
        logoImageView = UIImageView(image: ApplicationDependency.manager.theme.imageAssets.logoNoText)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        circleStokeLoadingView.startAnimating()
    }
}

extension LaunchLoadingViewController {

    private func setupUI() {
        setupLoadingView()
        setupLogoImageView()
        setupConstraints()
    }

    private func setupLoadingView() {
        self.view.addSubview(circleStokeLoadingView)
    }

    private func setupLogoImageView() {
        self.view.addSubview(logoImageView)
        logoImageView.contentMode = .scaleAspectFit
    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.width.equalToSuperview().dividedBy(3.2)
            make.height.equalTo(logoImageView.snp.width).dividedBy(1.75)
        }
    }
}

