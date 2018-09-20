//
//  ConfirmAddressViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

final class ConfirmAddressViewController: BaseViewController {

    private let viewModel: ConfirmAddressViewModel

    init(location: GMDetailLocation) {
        self.viewModel = ConfirmAddressViewModel(location: location)
        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()
    }
}

extension ConfirmAddressViewController {

    private func setupUI() {
        self.navigationItem.title = "Confirm Address"
    }

    private func setupConstraints() {
        
    }
}
