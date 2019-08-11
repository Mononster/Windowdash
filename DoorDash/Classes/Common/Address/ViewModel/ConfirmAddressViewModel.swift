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
    let aptNumber: String?
    let instruction: String?
    let dataStore: DataStoreType

    init(location: GMDetailLocation,
         aptNumber: String? = nil,
         instruction: String? = nil,
         dataStore: DataStoreType) {
        self.location = location
        self.aptNumber = aptNumber
        self.instruction = instruction
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

    func postNewUserAddress(completion: @escaping (Int64?, Error?) -> ()) {
        guard let currentUser = ApplicationEnvironment.current.currentUser else {
            return
        }
        let service = UserAPIService()
        service.postUserDeliveryInfo(location: location, aptNumber: aptNumber, instruction: instruction) { (address, error) in
            if let error = error as? UserAPIError {
                completion(nil, error)
                return
            }
            guard let address = address else {
                return
            }
            let updatedUser = User(
                id: currentUser.id,
                phoneNumber: currentUser.phoneNumber,
                lastName: currentUser.lastName,
                firstName: currentUser.firstName,
                email: currentUser.email,
                defaultAddress: address,
                defaultCard: currentUser.defaultCard,
                isGuest: currentUser.isGuest
            )
            ApplicationEnvironment.updateCurrentUser(updatedUser: updatedUser)
            try? updatedUser.savePersistently(to: self.dataStore)
            completion(address.id, nil)
        }
    }
}
