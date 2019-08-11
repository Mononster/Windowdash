//
//  UserResponseModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import SwiftyJSON

final class UserResponseModel: NetworkResponseModel {

    let user: User

    init(user: User) {
        self.user = user
    }

    static func from(_ data: JSON) throws -> UserResponseModel {
        let user = try JSONDecoder().decode(
            User.self, from: data.rawData()
        )
        return UserResponseModel(user: user)
    }
}
