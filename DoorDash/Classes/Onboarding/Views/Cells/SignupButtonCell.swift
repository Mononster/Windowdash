//
//  SignupButtonCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class SignupButtonCell: UICollectionViewCell {

    static let height: CGFloat = 62
    private let button: LoadingButton
    private var buttonAction: (() -> ())?

    override init(frame: CGRect) {
        button = LoadingButton()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(action: @escaping (() -> ()), mode: SignupMode) {
        self.buttonAction = action
        self.button.setTitle(mode.rawValue, for: .normal)
    }

    func stopAnimation() {
        button.hideLoading()
    }

    func startAnimaton() {
        button.showLoading()
    }
}

extension SignupButtonCell {

    private func setupUI() {
        setupButton()
        setupConstraints()
    }

    private func setupButton() {
        addSubview(button)
        button.setTitleColor(ApplicationDependency.manager.theme.colors.white, for: .normal)
        button.titleLabel?.font = ApplicationDependency.manager.theme.fonts.medium18
        button.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        button.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
}

extension SignupButtonCell {

    @objc
    func buttonTapped() {
        self.buttonAction?()
    }
}
