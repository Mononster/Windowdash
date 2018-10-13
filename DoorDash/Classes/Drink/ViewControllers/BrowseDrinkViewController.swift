//
//  BrowseDrinkViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class BrowseDrinkViewController: BaseViewController, NVActivityIndicatorViewable {
    override init() {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            PaymentActivityHUD.shared.show(initialMessage: "Adding...", viewToAdd: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                PaymentActivityHUD.shared.showSuccess(message: "Added!", completion: nil)
            }
        }
    }
}

extension BrowseDrinkViewController {

    private func setupUI() {
    }
}
