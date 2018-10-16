//
//  GradientButtonView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class GradientButtonView: UIView {

    let gradientView: GradientView
    let container: UIView
    static let height: CGFloat = 48 + 45 + 70

    override init(frame: CGRect) {
        gradientView = GradientView()
        container = UIView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GradientButtonView {

    private func setupUI() {
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        setupContainer()
        setupGradientView()
        setupConstraints()
    }

    private func setupContainer() {
        self.addSubview(container)
        container.backgroundColor = ApplicationDependency.manager.theme.colors.white
    }

    private func setupGradientView() {
        self.addSubview(gradientView)
        gradientView.isUserInteractionEnabled = false
        self.gradientView.gradientBackgroundColor = ApplicationDependency.manager.theme.colors.white
    }

    private func setupConstraints() {
        container.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48 + 45)
        }

        gradientView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(container.snp.top)
            make.height.equalTo(70)
        }
    }
}
