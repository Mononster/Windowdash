//
//  DasherInstructionsInputCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

protocol DasherInstructionsInputCellDelegate: class {
    func userUpdatedInput(text: String)
}

final class DasherInstructionsInputCell: UICollectionViewCell {

    static let height: CGFloat = 200 + 16
    private let textView: UITextView

    weak var delegate: DasherInstructionsInputCellDelegate?

    override init(frame: CGRect) {
        textView = UITextView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DasherInstructionsInputCell {

    private func setupUI() {
        setupTextView()
        setupConstraints()
    }

    private func setupTextView() {
        addSubview(textView)
        textView.text = " DASHER INSTRUCTIONS"
        textView.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        textView.backgroundColor = ApplicationDependency.manager.theme.colors.white
        textView.setBorder(.all, color: ApplicationDependency.manager.theme.colors.separatorGray, borderWidth: 0.4)
        textView.font = ApplicationDependency.manager.theme.fonts.bold12
        textView.delegate = self
    }

    private func setupConstraints() {
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
    }
}

extension DasherInstructionsInputCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ApplicationDependency.manager.theme.colors.doorDashDarkGray {
            textView.text = nil
            textView.textColor = ApplicationDependency.manager.theme.colors.black
            textView.font = ApplicationDependency.manager.theme.fonts.medium14
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = " DASHER INSTRUCTIONS"
            textView.font = ApplicationDependency.manager.theme.fonts.bold12
            textView.textColor = ApplicationDependency.manager.theme.colors.doorDashDarkGray
        } else {
            //comment = textView.text
            delegate?.userUpdatedInput(text: textView.text)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


