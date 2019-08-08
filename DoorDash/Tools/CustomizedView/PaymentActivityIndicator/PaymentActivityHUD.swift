//
//  PaymentActivityHUD.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

private let hudSize = CGSize(width: 60, height: 60)

final class PaymentActivityHUD: UIView {

    static let shared: PaymentActivityHUD = PaymentActivityHUD()

    private var activityView: PaymentActivityView?
    private let containerView: UIView
    private let messageLabel: UILabel

    var isShow: Bool = false

    private init() {
        containerView = UIView()
        messageLabel = UILabel()
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(initialMessage: String, viewToAdd: UIView) {
        viewToAdd.addSubview(containerView)
        setupActivityView()
        setupConstraints()
        self.messageLabel.text = initialMessage
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.containerView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.activityView?.startAnimation()
        }
    }

    func showSuccess(message: String, completion: (() -> ())?) {
        self.activityView?.updateState(success: true)

        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = 0.4
        messageLabel.layer.add(animation, forKey: "fade")
        messageLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion?()
        }
    }

    func hide() {
        self.containerView.removeFromSuperview()
    }
}

extension PaymentActivityHUD {

    private func setupUI() {
        self.containerView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        setupActivityView()
        setupLabel()
    }

    private func setupActivityView() {
        activityView?.removeFromSuperview()
        let centerX = UIScreen.main.bounds.width / 2 - hudSize.width / 2
        let centerY = UIScreen.main.bounds.height / 2 - hudSize.height / 2
        activityView = PaymentActivityView(frame: CGRect(x: centerX, y: centerY, width: hudSize.width, height: hudSize.height))
        containerView.addSubview(activityView!)
    }

    private func setupLabel() {
        self.containerView.addSubview(messageLabel)
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 1
        messageLabel.minimumScaleFactor = 0.5
        messageLabel.textAlignment = .center
        messageLabel.font = ApplicationDependency.manager.theme.fonts.medium16
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().offset(hudSize.height / 2 + 24)
        }
    }
}
