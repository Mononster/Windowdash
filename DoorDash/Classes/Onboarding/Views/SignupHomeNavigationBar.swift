//
//  SignupHomeNavigationBar.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

protocol SignupHomeNavigationBarDelegate: class {
    func userSwitched(mode: SignupMode)
    func backButtonTapped()
}

final class SignupHomeNavigationBar: UIView {

    private let segmentedControl: UISegmentedControl
    private let separator: Separator
    private let backButton: UIButton
    private let theme = ApplicationDependency.manager.theme
    weak var delegate: SignupHomeNavigationBarDelegate?
    let skipButton: UIButton
    var mode: SignupMode

    init(mode: SignupMode) {
        self.mode = mode
        segmentedControl = UISegmentedControl(
            items: [SignupMode.login.rawValue, SignupMode.register.rawValue]
        )
        separator = Separator.create()
        skipButton = UIButton()
        backButton = UIButton()
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SignupHomeNavigationBar {

    private func setupUI() {
        self.backgroundColor = theme.colors.white
        setupNavigationBar()
        setupSkipButton()
        setupBackButton()
        setupSeparator()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.addSubview(segmentedControl)
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: theme.fonts.medium14], for: .normal
        )
        segmentedControl.tintColor = theme.colors.doorDashRed
        segmentedControl.backgroundColor = theme.colors.white
        segmentedControl.addTarget(self, action: #selector(toggleSwithed(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = mode == .register ? 1 : 0
    }

    private func setupSkipButton() {
        self.addSubview(skipButton)
        skipButton.tintColor = theme.colors.doorDashRed
        skipButton.backgroundColor = .clear
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(theme.colors.doorDashRed, for: .normal)
        skipButton.titleLabel?.font = theme.fonts.medium18
    }

    private func setupBackButton() {
        self.addSubview(backButton)
        backButton.tintColor = theme.colors.doorDashRed
        backButton.backgroundColor = .clear
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(theme.colors.doorDashRed, for: .normal)
        backButton.setImage(theme.imageAssets.backTriangleIcon, for: .normal)
        backButton.titleLabel?.font = theme.fonts.medium18
        backButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 12)
        backButton.addTarget(self, action: #selector(userTappedBackButton), for: .touchUpInside)
    }

    private func setupSeparator() {
        self.addSubview(separator)
    }

    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(180)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }

        backButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalTo(segmentedControl)
            make.width.equalTo(60)
            make.height.equalTo(segmentedControl)
        }

        skipButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(segmentedControl)
            make.width.equalTo(50)
            make.height.equalTo(segmentedControl)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
}

extension SignupHomeNavigationBar {

    @objc
    private func toggleSwithed(_ segmentedControl: UISegmentedControl) {
        guard let mode = SignupMode(rawValue: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? "") else { return }
        self.delegate?.userSwitched(mode: mode)
    }

    @objc
    private func userTappedBackButton() {
        delegate?.backButtonTapped()
    }
}
