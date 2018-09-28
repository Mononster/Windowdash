//
//  User.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 {
 "last_name": "Zhan",
 "social_accounts": [],
 "object_type": "consumer.consumer",
 "is_repeat_consumer": false,
 "default_card": null,
 "referral_code": "Marvin-Zhan-7516",
 "referree_amount_monetary_fields": {
 "display_string": "$7.00",
 "unit_amount": 700
 },
 "id": 50813315,
 "default_currency": "USD",
 "first_name": "Marvin",
 "referrer_amount_monetary_fields": {
 "display_string": "$7.00",
 "unit_amount": 700
 },
 "order_count": 0,
 "show_alcohol_experience": false,
 "receive_marketing_push_notifications": true,
 "default_address": null,
 "email": "marvin.zhan.ztq123@gmail.com",
 "channel": "",
 "phone_number": "(415) 866-5357",
 "has_usable_password": true,
 "referrer_amount": 700,
 "account_credits": 0,
 "receive_text_notifications": true,
 "default_country": "US",
 "receive_push_notifications": false,
 "has_accepted_latest_terms_of_service": true,
 "latest_version_of_terms_of_service": "1.0",
 "social_data": [],
 "only_ordered_once": true,
 "is_guest": false,
 "default_substitution_preference": "",
 "referree_amount": 700
 }
 */

public struct User {

    public enum UserCodingKeys: String, CodingKey {
        case id
        case phoneNumber = "phone_number"
        case lastName = "last_name"
        case firstName = "first_name"
        case email
        case defaultAddress = "default_address"
        case isGuest = "is_guest"
    }

    public let id: Int64
    public let phoneNumber: String?
    public let lastName: String
    public let firstName: String
    public let email: String
    public let defaultAddress: DeliveryAddress?
    public let isGuest: Bool

    public init(id: Int64,
                phoneNumber: String?,
                lastName: String,
                firstName: String,
                email: String,
                defaultAddress: DeliveryAddress?,
                isGuest: Bool) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.defaultAddress = defaultAddress
        self.isGuest = isGuest
    }
}

extension User: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let phoneNumber: String? = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        let firstName: String = try values.decode(String.self, forKey: .firstName)
        let lastName: String = try values.decode(String.self, forKey: .lastName)
        let email: String = try values.decode(String.self, forKey: .email)
        let defaultAddress: DeliveryAddress? = try values.decodeIfPresent(DeliveryAddress.self, forKey: .defaultAddress)
        let isGuest: Bool = try values.decode(Bool.self, forKey: .isGuest)
        self.init(id: id,
                  phoneNumber: phoneNumber,
                  lastName: lastName,
                  firstName: firstName,
                  email: email,
                  defaultAddress: defaultAddress,
                  isGuest: isGuest)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(defaultAddress, forKey: .defaultAddress)
        try container.encode(isGuest, forKey: .isGuest)
    }
}

extension User {
    func exactlyEqual(otherUser: User) -> Bool {
        return self.id == otherUser.id &&
            self.phoneNumber == otherUser.phoneNumber &&
            self.firstName == otherUser.firstName &&
            self.lastName == otherUser.lastName &&
            self.email == otherUser.email &&
            self.defaultAddress == otherUser.defaultAddress &&
            self.isGuest == otherUser.isGuest
    }
}

extension User: Equatable {}

public func == (lhs: User, rhs: User) -> Bool {
    return lhs.exactlyEqual(otherUser: rhs)
}

/*
 {
 "last_name": "Zhan",
 "social_accounts": [],
 "object_type": "consumer.consumer",
 "is_repeat_consumer": false,
 "default_card": null,
 "referral_code": "Marvin-Zhan-5329",
 "referree_amount_monetary_fields": {
 "display_string": "$7.00",
 "unit_amount": 700
 },
 "id": 50810930,
 "default_currency": "USD",
 "first_name": "Marvin",
 "referrer_amount_monetary_fields": {
 "display_string": "$7.00",
 "unit_amount": 700
 },
 "order_count": 0,
 "show_alcohol_experience": true,
 "receive_marketing_push_notifications": true,
 "default_address": {
     "city": "San Francisco",
     "manual_lng": null,
     "district": {
         "shortname": "IRCH",
         "first_delivery_price": 0,
         "is_active": true,
         "id": 114,
         "name": "Inner Richmond"
     },
     "subpremise": "",
     "object_type": "consumer.address",
     "street": "750 7th Avenue",
     "id": 46648010,
     "timezone": "US/Pacific",
     "printable_address": "750 7th Ave, San Francisco, CA 94118, USA",
     "state": "CA",
     "shortname": "750 7th Ave",
     "submarket": "San Francisco",
     "lat": 37.7743771,
     "driver_instructions": "",
     "lng": -122.4646919,
     "submarket_id": 6,
     "manual_lat": null,
     "market": "Northern California",
     "zip_code": "94118"
 },
 "email": "marvin.zhan.ztq@gmail.com",
 "channel": "",
 "phone_number": "(415) 866-5357",
 "has_usable_password": true,
 "referrer_amount": 700,
 "account_credits": 0,
 "receive_text_notifications": true,
 "default_country": "US",
 "receive_push_notifications": false,
 "has_accepted_latest_terms_of_service": true,
 "latest_version_of_terms_of_service": "1.0",
 "social_data": [],
 "only_ordered_once": true,
 "is_guest": false,
 "default_substitution_preference": "",
 "referree_amount": 700
 }
 */








