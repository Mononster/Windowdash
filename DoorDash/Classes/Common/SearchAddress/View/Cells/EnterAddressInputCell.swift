//
//  EnterAddressInputCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import SnapKit

enum EnterAddressInputType: String {
    case apt = "Apt/Suite"
    case instructions = "Instructions"
}

protocol EnterAddressInputCellDelegate: class {
    func updateInputResult(type: EnterAddressInputType, value: String)
    func completeInputing()
}

final class EnterAddressInputCell: UICollectionViewCell {

    private let titleLabel: UILabel
    let inputField: UITextField

    var type: EnterAddressInputType = .apt
    weak var delegate: EnterAddressInputCellDelegate?

    static let height: CGFloat = 50

    override init(frame: CGRect) {
        titleLabel = UILabel()
        inputField = UITextField()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(type: EnterAddressInputType) {
        self.titleLabel.text = type.rawValue
        self.type = type
    }
}

extension EnterAddressInputCell {

    private func setupUI() {
        backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupTitleLabel()
        setupInputField()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fonts.bold16
        titleLabel.textAlignment = .right
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupInputField() {
        self.addSubview(inputField)
        inputField.clearButtonMode = .whileEditing
        inputField.autocorrectionType = .no
        inputField.autocapitalizationType = .none
        inputField.font = ApplicationDependency.manager.theme.fonts.medium15
        inputField.textColor = ApplicationDependency.manager.theme.colors.black
        inputField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                             for: .editingChanged)
        inputField.delegate = self
        inputField.placeholder = "Optional"
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.height.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.32)
        }

        inputField.snp.makeConstraints { (make) in
            make.height.centerY.trailing.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
        }
    }
}

extension EnterAddressInputCell: UITextFieldDelegate {

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = inputField.text else {
            return
        }
        delegate?.updateInputResult(type: type, value: text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.completeInputing()
        return true
    }
}
