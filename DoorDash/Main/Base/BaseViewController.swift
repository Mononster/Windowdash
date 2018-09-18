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

class BaseViewController: UIViewController {

    let theme = ApplicationDependency.manager.theme

    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.empty
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ApplicationDependency.manager.theme.colors.white
    }

    @objc func adjustViewWhenKeyboardShow(notification: NSNotification) {

    }

    @objc func adjustViewWhenKeyboardDismiss(notification: NSNotification) {

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
