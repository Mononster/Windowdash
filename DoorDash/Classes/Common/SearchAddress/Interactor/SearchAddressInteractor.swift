//
//  SearchAddressInteractor.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

struct SearchAddressItemModel: Equatable {

    let id: Int64
    let referenceID: String?
    let placeName: String
    let placeAddress: String
    let instruction: String?
    let selected: Bool

    init(id: Int64,
         referenceID: String? = nil,
         placeName: String,
         placeAddress: String,
         instruction: String?,
         selected: Bool) {
        self.id = id
        self.referenceID = referenceID
        self.placeName = placeName
        self.placeAddress = placeAddress
        self.instruction = instruction
        self.selected = selected
    }
}

func == (lhs: SearchAddressItemModel, rhs: SearchAddressItemModel) -> Bool {
    return lhs.id == rhs.id && lhs.referenceID == rhs.referenceID && lhs.placeName == rhs.placeName && lhs.placeAddress == rhs.placeAddress && lhs.instruction == rhs.instruction && lhs.selected == rhs.selected
}

final class SearchAddressInteractor {

    private let presenter: SearchAddressPresenterType
    private let apiService: UserAPIService
    private let dataStore: DataStoreType

    private var currentSelectedLocation: GMDetailLocation?
    private var currentSearchResult: [SearchAddressItemModel] = []
    private var inputResults: [EnterAddressInputType: String] = [:]

    init(presenter: SearchAddressPresenterType, apiService: UserAPIService) {
        self.presenter = presenter
        self.apiService = apiService
        self.dataStore = ApplicationEnvironment.current.dataStore
    }

    func handleSelectedAddress(model: SearchAddressItemModel) {
        guard !model.selected else {
            presenter.dimissModule()
            return
        }
        if let refID = model.referenceID {
            presenter.presentInitLoadingState(didUpdatedInput: didUpdatedSearchItem)
            let service = GooglePlaceAPIService()
            service.fetchDetailPlace(referenceID: refID) { (location) in
                guard let location = location else { return }
                self.currentSelectedLocation = location
                self.presenter.presentAddressResultState(
                    location: location,
                    didUpdateInstruction: self.didUpdatedAddressDetail,
                    confirmAction: self.confirmEnterAddress,
                    didUpdatedInput: self.didUpdatedSearchItem
                )
            }
        } else {
            updateUserDefaultAddress(id: model.id) {
                self.presenter.presentChangedAddress()
            }
        }
    }

    private func updateUserDefaultAddress(id: Int64, completion: @escaping (() -> Void)) {
        apiService.updateUserDefaultAddres(id: String(id)) { (userModel, error) in
            if let error = error {
                log.error(error)
                completion()
                return
            }
            guard let model = userModel,
                let currUser = ApplicationEnvironment.current.currentUser else {
                completion()
                return
            }
            if model.user != currUser {
                ApplicationEnvironment.updateCurrentUser(updatedUser: model.user)
                try? model.user.savePersistently(to: self.dataStore)
            }
            completion()
        }
    }

    private func confirmEnterAddress() {
        guard let location = currentSelectedLocation else {
            return
        }
        let viewModel = ConfirmAddressViewModel(
            location: location,
            aptNumber: inputResults[.apt],
            instruction: inputResults[.instructions],
            dataStore: dataStore
        )
        viewModel.postNewUserAddress { (id, error) in
            if let error = error {
                log.error(error)
                return
            }
            guard let id = id else { return }
            self.updateUserDefaultAddress(id: id, completion: {
                self.presenter.presentChangedAddress()
            })
        }
    }

    private func didUpdatedAddressDetail(type: EnterAddressInputType, value: String) {
        inputResults[type] = value
    }
}

extension SearchAddressInteractor {

    func loadData() {
        presenter.presentInitLoadingState(didUpdatedInput: didUpdatedSearchItem)
        fetchUserAddresses()
    }

    private func fetchUserAddresses() {
        guard let user = ApplicationEnvironment.current.currentUser else { return }
        apiService.fetchUserAddresses { (responseModel, error) in
            if let error = error {
                log.error(error)
                return
            }
            guard let responseModel = responseModel else { return }
            let addresses = responseModel.addresses.map { address -> SearchAddressItemModel in
                let printableAddress = address.printableAddress
                let components = printableAddress.components(separatedBy: ", ")
                let placeAddress = Array(components.dropFirst()).joined(separator: ", ")
                return SearchAddressItemModel(id: address.id, placeName: components.first ?? "", placeAddress: placeAddress, instruction: address.driverInstructions, selected: user.defaultAddress?.id == address.id)
            }
            self.currentSearchResult = addresses
            self.presenter.presentDisplayData(
                addresses: addresses,
                canShowEmptyState: false,
                didUpdatedInput: self.didUpdatedSearchItem
            )
        }
    }

    private func didUpdatedSearchItem(text: String?) {
        guard let text = text else {
            loadData()
            return
        }
        guard !text.isEmpty else {
            loadData()
            return
        }
        searchAddress(query: text) { queries in
            if queries.predictions.isEmpty {
                self.presenter.presentDisplayData(addresses: [], canShowEmptyState: true, didUpdatedInput: self.didUpdatedSearchItem)
                return
            }
            let models = queries.predictions.map { (prediction) -> SearchAddressItemModel in
                let id = Int64(arc4random()) + (Int64(arc4random()) << 32)
                return SearchAddressItemModel(id: id, referenceID: prediction.referenceID, placeName: prediction.addressInfo.mainText, placeAddress: prediction.addressInfo.secondaryText, instruction: nil, selected: false)
            }
            self.presenter.presentDisplayData(
                addresses: models,
                canShowEmptyState: true,
                didUpdatedInput: self.didUpdatedSearchItem
            )
        }
    }

    private func searchAddress(query: String, completion: @escaping (QueriedAddresses) -> ()) {
        GMAutoCompleteManager.shared.decode(query) { (predictions) in
            guard let predictions = predictions else {
                completion(QueriedAddresses(predictions: []))
                return
            }
            let queries = QueriedAddresses(predictions: predictions.uniqueElements)
            completion(queries)
        }
    }
}
