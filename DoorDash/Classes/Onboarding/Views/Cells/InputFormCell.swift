//
//  InputFormCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-17.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

protocol InputFormCellDelegate: class {
    func updateInputResult(type: SignInputFieldType, value: String)
    func wakeUpInputField(type: SignInputFieldType)
}

final class InputFormCell: UICollectionViewCell {

    private let titleLabel: UILabel
    let inputField: UITextField
    let topSepartor: Separator
    let bottomSeparator: Separator

    var type: SignInputFieldType = .firstName
    // use to wake up next inputfield when user hit return key
    var nextType: SignInputFieldType?
    var isLastInputField: Bool = false

    weak var delegate: InputFormCellDelegate?

    static let height: CGFloat = 45

    override init(frame: CGRect) {
        titleLabel = UILabel()
        inputField = UITextField()
        topSepartor = Separator.create()
        bottomSeparator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(type: SignInputFieldType,
                   nextType: SignInputFieldType?,
                   isLastInputField: Bool) {
        self.titleLabel.text = type.rawValue
        self.type = type
        self.nextType = nextType
        self.isLastInputField = isLastInputField
        if type == .phoneNumber {
            self.inputField.keyboardType = .numberPad
        }

        if type == .password {
            self.inputField.isSecureTextEntry = true
            self.inputField.placeholder = "at least 8 characters"
        } else {
            self.inputField.placeholder = nil
        }

        if !isLastInputField {
            self.inputField.returnKeyType = .next
        } else {
            self.inputField.returnKeyType = .go
        }
    }
}

extension InputFormCell {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupSeparators()
        setupTitleLabel()
        setupInputField()
        setupConstraints()
    }

    private func setupSeparators() {
        addSubview(topSepartor)
        topSepartor.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.6)

        addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.6)
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.medium15
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
        inputField.font = ApplicationDependency.manager.theme.fontSchema.medium15
        inputField.textColor = ApplicationDependency.manager.theme.colors.black
        inputField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                             for: .editingChanged)
        inputField.delegate = self
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.height.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(
                SignInputFormSectionController.formLabelWidthRatio
            )
        }

        inputField.snp.makeConstraints { (make) in
            make.height.centerY.trailing.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
        }

        topSepartor.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.7)
        }

        bottomSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.7)
        }
    }
}

extension InputFormCell: UITextFieldDelegate {

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = inputField.text else {
            return
        }
        delegate?.updateInputResult(type: type, value: text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let type = nextType {
            self.delegate?.wakeUpInputField(type: type)
        }
        return true
    }
}

