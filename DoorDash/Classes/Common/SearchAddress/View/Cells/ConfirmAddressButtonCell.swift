//
//  ConfirmAddressButtonCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import SnapKit
import UIKit

final class ConfirmAddressButtonCell: UICollectionViewCell {

    private let actionButton: LoadingButton
    var actionButtonTapped: (() -> Void)?

    static let height: CGFloat = 24 + 48 + 24

    override init(frame: CGRect) {
        actionButton = LoadingButton(frame: .zero)
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.layer.cornerRadius = 8
    }

    func setupCell(buttonText: String, isLoading: Bool) {
        actionButton.setTitle(buttonText, for: .normal)
        actionButton.originalButtonText = buttonText
        if !isLoading {
            self.actionButton.hideLoading()
        }
    }
}

extension ConfirmAddressButtonCell {

    private func setupUI() {
        setupActionButton()
        setupConstraints()
    }

    private func setupActionButton() {
        addSubview(actionButton)
        actionButton.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        actionButton.setTitleColor(ApplicationDependency.manager.theme.colors.white, for: .normal)
        actionButton.contentHorizontalAlignment = .center
        actionButton.titleLabel?.font = ApplicationDependency.manager.theme.fonts.medium18
        actionButton.addTarget(self, action: #selector(userTappedActionButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}

extension ConfirmAddressButtonCell {

    @objc
    private func userTappedActionButton() {
        actionButton.showLoading()
        actionButtonTapped?()
    }
}
