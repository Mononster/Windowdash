//
//  BaseViewController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

typealias KeyboardInfo = (
    option: UIView.AnimationOptions,
    keyboardHeight: CGFloat,
    duration: Double
)

enum KeyboardState {
    case hide
    case show
}

enum BaseViewControllerStyle {
    case withCustomNavBar
    case nativeNavBar
}

class BaseViewController: UIViewController {

    let theme = ApplicationDependency.manager.theme
    var keyboardState: KeyboardState = .hide
    let loadingIndicator: LoadingIndicator
    let pageLoadingIndicator: LargeLoadingIndicator
    let tableViewPlaceHolder: UITableView

    init() {
        loadingIndicator = LoadingIndicator(frame: .zero)
        pageLoadingIndicator = LargeLoadingIndicator(frame: .zero)
        tableViewPlaceHolder = UITableView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.empty
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupDefaultLoadingViews()
        setupTableViewAsPlaceHolderView()
    }

    func setupDefaultLoadingViews() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.isHidden = true
        loadingIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
            if self.navigationController?.navigationBar.isHidden == false {
                make.centerY.equalToSuperview().offset(-ApplicationDependency.manager.theme.navigationBarHeight)
            } else {
                make.centerY.equalToSuperview()
            }
        }
        self.view.addSubview(pageLoadingIndicator)
        pageLoadingIndicator.isHidden = true
        pageLoadingIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
            if self.navigationController?.navigationBar.isHidden == false {
                make.centerY.equalToSuperview().offset(-ApplicationDependency.manager.theme.navigationBarHeight)
            } else {
                make.centerY.equalToSuperview()
            }
        }
    }

    func setupTableViewAsPlaceHolderView() {
        self.view.addSubview(tableViewPlaceHolder)
        tableViewPlaceHolder.isHidden = true
        tableViewPlaceHolder.separatorStyle = .singleLine
        tableViewPlaceHolder.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            if self.navigationController?.navigationBar.isHidden == false {
                make.top.equalToSuperview().offset(-ApplicationDependency.manager.theme.navigationBarHeight)
            } else {
                make.top.equalToSuperview()
            }
        }
    }

    @objc func adjustViewWhenKeyboardShow(notification: NSNotification) {

    }

    @objc func adjustViewWhenKeyboardDismiss(notification: NSNotification) {

    }

    func presentErrorAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BaseViewController {

    func obtainKeyboardInfo(from notification: NSNotification) -> KeyboardInfo? {
        guard let userInfo = notification.userInfo else {
            return nil
        }

        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value

        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        return (option: options,
                keyboardHeight: heightOffset,
                duration: duration ?? 0.25)
    }

    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViewWhenKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViewWhenKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
