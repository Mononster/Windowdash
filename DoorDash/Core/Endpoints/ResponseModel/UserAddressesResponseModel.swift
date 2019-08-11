//
//  UserAddressesResponseModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import SwiftyJSON

final class UserAddressesResponseModel: NetworkResponseModel {

    let addresses: [DeliveryAddress]

    init(addresses: [DeliveryAddress]) {
        self.addresses = addresses
    }

    static func from(_ data: JSON) throws -> UserAddressesResponseModel {
        let addresses = try JSONDecoder().decode(
            [DeliveryAddress].self, from: data.rawData()
        )
        return UserAddressesResponseModel(addresses: addresses)
    }
}
