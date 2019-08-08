//
//  PaymentMethodViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-30.
//  Copyright © 2018 Monster. All rights reserved.
//

final class PaymentMethodViewModel {

    let model: PaymentMethod
    let displayTitle: String
    let displaySubTitle: String
    var isSelected: Bool

    init(model: PaymentMethod) {
        self.model = model
        self.displayTitle = model.brand.rawValue + " ... " + model.lastFour
        self.displaySubTitle = (model.expMonth ?? "") + "/" + (model.expYear ?? "")
        isSelected = false
        if let user = ApplicationEnvironment.current.currentUser {
            if user.defaultCard?.id == model.id {
                isSelected = true
            }
        }
    }
}
