//
//  AddPaymentCardViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-28.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import Stripe

protocol AddPaymentCardViewControllerDelegate: class {
    func dismiss()
}

final class AddPaymentCardViewController: BaseViewController {

    private let navigationBar: CustomNavigationBar
    private let paymentTextField: STPPaymentCardTextField
    private let descriptionLabel: UILabel
    private let style: BaseViewControllerStyle
    private var rightBarButton: UIBarButtonItem?
    private let viewModel: AddPaymentCardViewModel

    weak var delegate: AddPaymentCardViewControllerDelegate?

    init(style: BaseViewControllerStyle) {
        self.style = style
        self.navigationBar = CustomNavigationBar.create()
        self.paymentTextField = STPPaymentCardTextField()
        self.descriptionLabel = UILabel()
        self.viewModel = AddPaymentCardViewModel()
        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc
    private func dismissButtonTapped() {
        self.delegate?.dismiss()
    }

    @objc
    private func saveButtonTapped() {
        viewModel.submitCardInfoToServer(cardNumber: paymentTextField.cardNumber,
                                         expirationYear: paymentTextField.expirationYear,
                                         expirationMonth: paymentTextField.expirationMonth,
                                         cvc: paymentTextField.cvc,
                                         postalCode: paymentTextField.postalCode)
        { errorMsg in
            if let errorMsg = errorMsg {
                self.presentErrorAlertView(title: "Error", message: errorMsg)
                return
            }
            self.delegate?.dismiss()
        }
    }
}

extension AddPaymentCardViewController {

    private func setupUI() {
        self.view.backgroundColor = theme.colors.backgroundDarkGray
        setupNavigationBar()
        setupPaymentInputField()
        setupDescriptionLabel()
        setupConstraints()
    }

    private func setupNavigationBar() {
        style == .withCustomNavBar ? setupCustomNavBar() : setupNativeNavBar()
    }

    private func setupNativeNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        rightBarButton?.setTitleTextAttributes([NSAttributedString.Key.font: theme.fonts.medium18], for: .normal)
        self.navigationItem.setRightBarButtonItems([rightBarButton!], animated: false)
        self.navigationItem.title = "Add Card"
        rightBarButton?.tintColor = theme.colors.doorDashGray
    }

    private func setupCustomNavBar() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(navigationBar)
        self.navigationBar.title = "Add Card"
        navigationBar.bottomLine.isHidden = true
        navigationBar.setLeftButton(normal: theme.imageAssets.backTriangleIcon,
                                    highlighted: theme.imageAssets.backTriangleIcon,
                                    title: "Back",
                                    titleColor: theme.colors.doorDashRed)
        navigationBar.setRightButton(title: "Save", titleColor: theme.colors.doorDashDarkGray)
        navigationBar.setRightButtonEnabled(false)
        navigationBar.onClickLeftButton = {
            self.dismissButtonTapped()
        }
        navigationBar.onClickRightButton = {
            self.saveButtonTapped()
        }
    }

    private func setupPaymentInputField() {
        self.view.addSubview(paymentTextField)
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 1
        paymentTextField.borderColor = theme.colors.separatorGray
        paymentTextField.layer.cornerRadius = 6
        paymentTextField.layer.masksToBounds = true
        paymentTextField.font = theme.fonts.medium16
        paymentTextField.cursorColor = theme.colors.doorDashRed
        paymentTextField.postalCodeEntryEnabled = true
        paymentTextField.backgroundColor = theme.colors.white
    }

    private func setupDescriptionLabel() {
        self.view.addSubview(descriptionLabel)
        descriptionLabel.textColor = theme.colors.doorDashDarkGray
        descriptionLabel.font = theme.fonts.medium14
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "This will update your existing payment card. This card will only be charged when you place an order."
    }

    private func setupConstraints() {
        paymentTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(40)
            if style == .withCustomNavBar {
                make.top.equalTo(navigationBar.snp.bottom).offset(60)
            } else {
                make.top.equalToSuperview().offset(60)
            }
            make.height.equalTo(60)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(paymentTextField.snp.bottom).offset(24)
        }
    }
}

extension AddPaymentCardViewController: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        let color = textField.isValid ? theme.colors.doorDashRed : theme.colors.doorDashGray
        if style == .withCustomNavBar {
            navigationBar.setRightButtonEnabled(textField.isValid)
            navigationBar.setRightButton(title: "Save", titleColor: color)
        } else {
            rightBarButton?.tintColor = color
        }
    }

    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {

    }

    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {

    }

    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {

    }
}
