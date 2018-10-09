//
//  MultiSelectionButton.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-08.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class MultiSelectionButton: UIButton {

    private let checkmarkImageView: UIImageView
    private let checkmarkBox: UIView

    override init(frame: CGRect) {
        checkmarkBox = UIView()
        checkmarkImageView = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggleCheckmark(selected: Bool) {
        self.checkmarkImageView.isHidden = !selected
        if checkmarkImageView.isHidden {
            checkmarkBox.setBorder(.all,
                                   color: ApplicationDependency.manager.theme.colors.separatorGray,
                                   borderWidth: 1.5)
            checkmarkBox.backgroundColor = ApplicationDependency.manager.theme.colors.white
        } else {
            checkmarkBox.layer.borderWidth = 0
            checkmarkBox.layer.borderColor = UIColor.clear.cgColor
            checkmarkBox.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        }
    }
}

extension MultiSelectionButton {

    private func setupUI() {
        setupCheckmark()
        setupConstraints()
    }

    private func setupCheckmark() {
        addSubview(checkmarkBox)
        checkmarkBox.setBorder(.all,
                               color: ApplicationDependency.manager.theme.colors.separatorGray,
                               borderWidth: 1.5)
        checkmarkBox.backgroundColor = ApplicationDependency.manager.theme.colors.white
        checkmarkBox.layer.cornerRadius = 4

        checkmarkBox.addSubview(checkmarkImageView)
        checkmarkImageView.image = ApplicationDependency.manager.theme.imageAssets.buttonCheckmark
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.clipsToBounds = true
        checkmarkImageView.isHidden = true
    }

    private func setupConstraints() {
        checkmarkBox.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        checkmarkImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
