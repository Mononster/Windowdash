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
    let dataStore: DataStoreType

    init(location: GMDetailLocation,
         dataStore: DataStoreType) {
        self.location = location
        self.dataStore = dataStore
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

    func sendUserLocation(completion: @escaping (String?) -> ()) {
        guard let currentUser = ApplicationEnvironment.current.currentUser else {
            completion("Error current user does not exist. WTF happend?")
            return
        }

        let service = UserAPIService()
        service.postUserDeliveryInfo(uid: String(currentUser.id), location: location) { (address, error) in
            if let error = error as? UserAPIError {
                completion(error.errorMessage)
                return
            }
            guard let address = address else {
                completion("Can't load address")
                return
            }
            let updatedUser = User(
                id: currentUser.id,
                phoneNumber: currentUser.phoneNumber,
                lastName: currentUser.lastName,
                firstName: currentUser.firstName,
                email: currentUser.email,
                defaultAddress: address
            )
            ApplicationEnvironment.updateCurrentUser(updatedUser: updatedUser)
            try? updatedUser.savePersistently(to: self.dataStore)
            completion(nil)
        }
    }
}
