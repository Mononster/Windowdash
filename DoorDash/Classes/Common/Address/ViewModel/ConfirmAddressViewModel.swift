//
//  ConfirmAddressViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

final class ConfirmAddressViewModel {

    let location: GMDetailLocation

    init(location: GMDetailLocation) {
        self.location = location
    }

    func generatePresentingModel() -> ConfirmAddressPresentModel {
        let components = location.address.components(separatedBy: ",")
        let title = components.first ?? ""
        var subTitle = ""
        for (i, component) in components.enumerated() {
            if i == 0 {
                continue
            }
            subTitle = subTitle + component + (i == components.count - 1 ? "" : ", ")
        }

        return ConfirmAddressPresentModel(addressTitle: title,
                                          addressSubtitle: subTitle,
                                          latitude: location.latitude ?? 0,
                                          longitude: location.longitude ?? 0)
    }
}
