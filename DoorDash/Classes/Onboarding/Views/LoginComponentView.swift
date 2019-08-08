//
//  LoginComponentView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginComponentViewDelegate: class {
    func continueWithGoogle()
    func continueWithFacebook()
}

final class LoginComponentView: UIView {

    private let facebookButton: UIButton
    private let googleButton: UIButton
    private let continueWithEmailLabel: UILabel

    let theme = ApplicationDependency.manager.theme
    weak var delegate: LoginComponentViewDelegate?

    static let height = 18 + 46 + 8 + 46 + 38

    override init(frame: CGRect) {
        facebookButton = IconedButton.button(
            image: theme.imageAssets.facebook,
            imageAlign: .left,
            imageInset: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 10))
        googleButton = IconedButton.button(
            image: theme.imageAssets.google,
            imageAlign: .left,
            imageInset: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 10))
        continueWithEmailLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginComponentView {

    func setupUI() {
        setupFacebookButton()
        setupGoogleButton()
        setupEmailLabel()
        setupConstraints()
    }

    func setupFacebookButton() {
        addSubview(facebookButton)
        facebookButton.layer.cornerRadius = 4.0
        facebookButton.backgroundColor = theme.colors.signInFacebookButtonColor
        facebookButton.setTitle("Continue with Facebook", for: .normal)
        facebookButton.titleLabel?.textAlignment = .center
        facebookButton.setTitleColor(theme.colors.white, for: .normal)
        facebookButton.titleLabel?.font = theme.fonts.medium18
        facebookButton.addTarget(self, action: #selector(facebookButtonClicked), for: .touchUpInside)
    }

    func setupGoogleButton() {
        addSubview(googleButton)
        googleButton.layer.cornerRadius = 4.0
        googleButton.backgroundColor = theme.colors.signInGoogleButtonColor
        googleButton.setTitle("Continue with Google", for: .normal)
        googleButton.titleLabel?.textAlignment = .center
        googleButton.setTitleColor(theme.colors.white, for: .normal)
        googleButton.titleLabel?.font = theme.fonts.medium18
        googleButton.addTarget(self, action: #selector(googleButtonClicked), for: .touchUpInside)
    }

    func setupEmailLabel() {
        addSubview(continueWithEmailLabel)
        continueWithEmailLabel.textColor = theme.colors.lightGray
        continueWithEmailLabel.font = theme.fonts.medium12
        continueWithEmailLabel.textAlignment = .center
        continueWithEmailLabel.adjustsFontSizeToFitWidth = true
        continueWithEmailLabel.minimumScaleFactor = 0.5
        continueWithEmailLabel.numberOfLines = 1
        continueWithEmailLabel.text = "or continue with email"
    }

    func setupConstraints() {
        googleButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(46)
            make.top.equalToSuperview().offset(18)
        }

        facebookButton.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(googleButton)
            make.top.equalTo(googleButton.snp.bottom).offset(8)
        }

        continueWithEmailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(facebookButton.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}

extension LoginComponentView {

    @objc func googleButtonClicked() {
        delegate?.continueWithGoogle()
    }

    @objc func facebookButtonClicked() {
        delegate?.continueWithFacebook()
    }
}
