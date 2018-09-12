//
//  BaseViewController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

typealias KeyboardInfo = (
    option: UIViewAnimationOptions,
    keyboardHeight: CGFloat,
    duration: Double
)

class BaseViewController: UIViewController {

    lazy var navigationBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar.createBar()
        navBar.barBackgroundColor = theme.colors.uwLifeRed
        navBar.setTintColor(color: .white)
        return navBar
    }()
    
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
        navigationController?.navigationBar.isHidden = true
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(navigationBar)
        if self.navigationController?.childViewControllers.count != 1 {
            navigationBar.setLeftButton(title: "X", titleColor: theme.colors.white)
        }
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

        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value

        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        let options = UIViewAnimationOptions(rawValue: UInt(curve!) << 16 | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        return (option: options,
                keyboardHeight: heightOffset,
                duration: duration ?? 0.25)
    }

    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViewWhenKeyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustViewWhenKeyboardDismiss), name: .UIKeyboardWillHide, object: nil)
    }
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
