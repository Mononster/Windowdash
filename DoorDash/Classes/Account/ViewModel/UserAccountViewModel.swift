//
//  UserAccountViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-22.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

enum UserAccountPageType: String {
    case basicInfo = "Basic Information"
    case paymentCards = "Payment Cards"
    case addresses = "Addresses"
    case linkFacebook = "Link Facebook"
    case deliverySupport = "Delivery Support"
    case accountCredits = "Account Credits"
    case referFriends = "Refer Friends, Get $"
    case deliveryPush = "Delivery Push Notifications"
    case deliverySMS = "Delivery SMS Notifications"
    case promoPush = "Promotional Push Notifications"
    case becomeDasher = "Become a Dasher"
    case logout = "Log Out"
    case appVersion = "App Version"
}

enum UserAccountSectionsType: String {
    case account = "Account"
    case notifications = "NOTIFICATIONS"
    case more = "MORE"
    case version = "Version"
}

final class UserAccountPageSectionModel: NSObject, ListDiffable {
    let models: [UserAccountPagePresentingModel]
    let type: UserAccountSectionsType

    init(models: [UserAccountPagePresentingModel], type: UserAccountSectionsType) {
        self.models = models
        self.type = type
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class UserAccountPagePresentingModel: NSObject, ListDiffable {

    let title: String
    let subTitle: String?
    let toggleOn: Bool?
    let type: UserAccountPageType

    init(title: String,
         subTitle: String? = nil,
         toggleOn: Bool? = nil,
         type: UserAccountPageType) {
        self.title = title
        self.subTitle = subTitle
        self.type = type
        self.toggleOn = toggleOn
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class UserAccountViewModel {

    let service: UserAPIService
    let dataStore: DataStoreType

    init(service: UserAPIService, dataStore: DataStoreType) {
        self.service = service
        self.dataStore = dataStore
    }

    func generateModelsForAccountDetails() -> UserAccountPageSectionModel {
        guard let user = ApplicationEnvironment.current.currentUser else {
            return UserAccountPageSectionModel(models: [], type: .account)
        }
        let models = [
            UserAccountPagePresentingModel(
                title: user.firstName + " " + user.lastName,
                subTitle: "Change your account information",
                type: .basicInfo
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.paymentCards.rawValue,
                subTitle: "Add a credit or debit card",
                type: UserAccountPageType.paymentCards
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.addresses.rawValue,
                subTitle: "Add or remove a delivery address",
                type: UserAccountPageType.addresses
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.linkFacebook.rawValue,
                type: UserAccountPageType.linkFacebook
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.deliverySupport.rawValue,
                type: UserAccountPageType.deliverySupport
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.accountCredits.rawValue,
                subTitle: "$0.00",
                type: UserAccountPageType.linkFacebook
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.referFriends.rawValue,
                type: UserAccountPageType.referFriends
            )
        ]
        return UserAccountPageSectionModel(models: models, type: .account)
    }

    func generateModelsForNotifications() -> UserAccountPageSectionModel {
        guard ApplicationEnvironment.current.currentUser != nil else {
            return UserAccountPageSectionModel(models: [], type: .notifications)
        }
        let models = [
            UserAccountPagePresentingModel(
                title: UserAccountPageType.deliveryPush.rawValue,
                toggleOn: false,
                type: .deliveryPush
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.deliverySMS.rawValue,
                toggleOn: false,
                type: .deliverySMS
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.promoPush.rawValue,
                toggleOn: true,
                type: .promoPush
            )
        ]
        return UserAccountPageSectionModel(models: models, type: .notifications)
    }

    func generateModelsForMoreSection() -> UserAccountPageSectionModel {
        let models = [
            UserAccountPagePresentingModel(
                title: UserAccountPageType.becomeDasher.rawValue,
                type: .becomeDasher
            ),
            UserAccountPagePresentingModel(
                title: UserAccountPageType.logout.rawValue,
                type: .logout
            )
        ]
        return UserAccountPageSectionModel(models: models, type: .more)
    }

    func generateModelsForAppVersionSection() -> UserAccountPageSectionModel {
        let models = [
            UserAccountPagePresentingModel(
                title: "version 3.0.91b411",
                type: .appVersion
            )
        ]
        return UserAccountPageSectionModel(models: models, type: .version)
    }

    func fetchUserAccount(completion: @escaping (String?) -> ()) {
        guard let uid = ApplicationEnvironment.current.currentUser?.id else {
            completion("User not logged in, this function shouldn't be called, wtf happend?")
            return
        }

        service.fetchUserAccount(uid: String(uid)) { (user, error) in
            if let error = error as? UserAPIError {
                completion(error.errorMessage)
                return
            }
            guard let user = user, let currUser = ApplicationEnvironment.current.currentUser else {
                completion(nil)
                return
            }
            if user != currUser {
                ApplicationEnvironment.updateCurrentUser(updatedUser: user)
                try? user.savePersistently(to: self.dataStore)
            }
            completion(nil)
        }
    }
}
