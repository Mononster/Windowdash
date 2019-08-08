//
//  InputApartmentView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class InputApartmentView: UIView {
    
    private let topLabel: UILabel
    let textField: UITextField

    static let height: CGFloat = 70

    override init(frame: CGRect) {
        textField = UITextField()
        topLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputApartmentView {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupTopLabel()
        setupTextField()
        setupConstraints()
    }

    private func setupTopLabel() {
        addSubview(topLabel)
        topLabel.text = "APARTMENT#(OPTIONAL)"
        topLabel.backgroundColor = .clear
        topLabel.numberOfLines = 1
        topLabel.font = ApplicationDependency.manager.theme.fonts.heavy12
        topLabel.textColor = ApplicationDependency.manager.theme.colors.gray.withAlphaComponent(0.9)
    }

    private func setupTextField() {
        addSubview(textField)
        textField.layer.borderColor = ApplicationDependency.manager.theme.colors.gray.cgColor
        textField.font = ApplicationDependency.manager.theme.fonts.medium15
        textField.textColor = ApplicationDependency.manager.theme.colors.black
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }

    private func setupConstraints() {
        topLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(20)
        }

        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(topLabel)
            make.top.equalTo(topLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalToSuperview().offset(-4)
        }
    }
}
