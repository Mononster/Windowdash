//
//  SignupAgreementCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-17.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class SignupAgreementCell: UICollectionViewCell {

    private let agreementLabel: UILabel
    static let height: CGFloat = 70

    override init(frame: CGRect) {
        agreementLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(text: NSAttributedString) {
        self.agreementLabel.attributedText = text
    }
}

extension SignupAgreementCell {

    private func setupUI() {
        setupAgreementLabel()
        setupConstraints()
    }

    private func setupAgreementLabel() {
        self.addSubview(agreementLabel)
        agreementLabel.numberOfLines = 0
        agreementLabel.adjustsFontSizeToFitWidth = true
        agreementLabel.minimumScaleFactor = 0.5
        agreementLabel.textAlignment = .left
    }

    private func setupConstraints() {
        agreementLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.height.equalToSuperview()
        }
    }
}

