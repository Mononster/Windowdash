//
//  EnterAddressCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol EnterAddressCellDelegate: class {
    func userDidEdited(text: String)
}

final class EnterAddressCell: UICollectionViewCell {

    private let topLabel: UILabel
    let separator: Separator
    let textField: UITextField
    weak var delegate: EnterAddressCellDelegate?

    static let height: CGFloat = 70

    override init(frame: CGRect) {
        textField = UITextField()
        separator = Separator.create()
        topLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EnterAddressCell {

    private func setupUI() {
        setupTopLabel()
        setupTextField()
        setupSeparator()
        setupConstraints()
    }

    private func setupSeparator() {
        separator.isHidden = true
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray
        addSubview(separator)
    }

    private func setupTopLabel() {
        addSubview(topLabel)
        topLabel.text = "STREET ADDRESS"
        topLabel.backgroundColor = .clear
        topLabel.numberOfLines = 1
        topLabel.font = ApplicationDependency.manager.theme.fontSchema.heavy12
        topLabel.textColor = ApplicationDependency.manager.theme.colors.gray.withAlphaComponent(0.9)
    }

    private func setupTextField() {
        addSubview(textField)
        textField.layer.borderColor = ApplicationDependency.manager.theme.colors.gray.cgColor
        textField.font = ApplicationDependency.manager.theme.fontSchema.medium15
        textField.textColor = ApplicationDependency.manager.theme.colors.black
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
    }

    private func setupConstraints() {
        topLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(20)
        }

        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(topLabel)
            make.top.equalTo(topLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalToSuperview().offset(-4)
        }

        separator.snp.makeConstraints { (make) in
            make.height.equalTo(0.7)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension EnterAddressCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text {
            var finalString = ""
            if string.count > 0 {
                finalString = oldText + string
            } else if oldText.count > 0 {
                finalString = String(oldText.dropLast())
            }
            delegate?.userDidEdited(text: finalString)
        }
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.userDidEdited(text: "")
        return false
    }
}


