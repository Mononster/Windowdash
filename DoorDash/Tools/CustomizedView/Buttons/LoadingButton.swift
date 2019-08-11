//
//  LoadingButton.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {

    var originalButtonText: String?
    var originalButtonColor: UIColor?
    var activityIndicator: NVActivityIndicatorView

    override init(frame: CGRect) {
        let loadingSize: CGFloat = 30
        let loadingViewFrame = CGRect(
            x: 0,
            y: 0,
            width: loadingSize,
            height: loadingSize
        )
        activityIndicator = NVActivityIndicatorView(
            frame: loadingViewFrame,
            type: .circleStrokeSpin,
            lineWidth: 2
        )
        super.init(frame: CGRect.zero)
        activityIndicator.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showLoading() {
        originalButtonColor = self.backgroundColor
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        showSpinning()
        self.isUserInteractionEnabled = false
    }

    func hideLoading() {
        backgroundColor = originalButtonColor ?? ApplicationDependency.manager.theme.colors.doorDashRed
        self.setTitle(self.originalButtonText ?? self.titleLabel?.text, for: .normal)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.isUserInteractionEnabled = true
    }

    private func showSpinning() {
        backgroundColor = .clear
        addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(activityIndicator.snp.height)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
}
