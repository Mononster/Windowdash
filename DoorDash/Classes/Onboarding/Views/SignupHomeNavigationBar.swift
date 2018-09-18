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
}

final class SignupHomeNavigationBar: UIView {

    private let segmentedControl: UISegmentedControl
    private let separator: Separator
    private let theme = ApplicationDependency.manager.theme
    weak var delegate: SignupHomeNavigationBarDelegate?
    var mode: SignupMode

    init(mode: SignupMode) {
        self.mode = mode
        segmentedControl = UISegmentedControl(
            items: ["Sign Up", "Sign In"]
        )
        separator = Separator.create()
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
        setupSeparator()
        setupConstraints()
    }

    private func setupNavigationBar() {
        self.addSubview(segmentedControl)
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.font: theme.fontSchema.semiBold12], for: .normal
        )
        segmentedControl.tintColor = theme.colors.doorDashRed
        segmentedControl.backgroundColor = theme.colors.white
        segmentedControl.addTarget(self, action: #selector(toggleSwithed(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = mode == .register ? 0 : 1
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

        separator.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
}

extension SignupHomeNavigationBar {

    @objc
    func toggleSwithed(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.delegate?.userSwitched(mode: .register)
        } else {
            self.delegate?.userSwitched(mode: .login)
        }
    }
}
