//
//  SocialLoginCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-17.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class SocialLoginCell: UICollectionViewCell {
    private let loginComponentView: LoginComponentView

    override init(frame: CGRect) {
        loginComponentView = LoginComponentView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocialLoginCell {

    private func setupUI() {
        setupLoginView()
        setupConstraints()
    }

    private func setupLoginView() {
        self.addSubview(loginComponentView)
    }

    private func setupConstraints() {
        self.loginComponentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
