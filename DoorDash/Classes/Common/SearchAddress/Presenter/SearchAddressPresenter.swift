//
//  SearchAddressPresenter.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

protocol SearchAddressPresenterOutput: class {
    func showPresentationData(models: [ListDiffable])
    func showInitLoadingState()
    func hideLoadingState()
    func showChangedAddress()
    func dimissModule()
}

protocol SearchAddressPresenterType: class {
    func presentDisplayData(addresses: [SearchAddressItemModel],
                            didUpdatedInput: ((String?) -> Void)?)
    func presentInitLoadingState(didUpdatedInput: ((String?) -> Void)?)
    func presentAddressResultState(location: GMDetailLocation,
                                   didUpdateInstruction: ((EnterAddressInputType, String) -> Void)?,
                                   confirmAction: (() -> Void)?,
                                   didUpdatedInput: ((String?) -> Void)?)
    func presentChangedAddress()
    func dimissModule()
}

final class SearchAddressPresenter: SearchAddressPresenterType {

    weak var output: SearchAddressPresenterOutput?

    func presentDisplayData(addresses: [SearchAddressItemModel],
                            didUpdatedInput: ((String?) -> Void)?) {
        var models: [ListDiffable] = [
            SearchAddressInputPresentingModel(didUpdatedInput: didUpdatedInput),
        ]
        if !addresses.isEmpty {
            models.append(contentsOf: addresses.map { SearchAddressItemPresentingModel(item: $0) })
        } else {
            models.append(SearchAddressEmptyResultPresentingModel(
                emptyText: "Sorry, we couldn't find that address. Try entering your address without apt/suite/floor numbers."
            ))
        }
        output?.showPresentationData(models: models)
        output?.hideLoadingState()
    }

    func presentInitLoadingState(didUpdatedInput: ((String?) -> Void)?) {
        let models: [ListDiffable] = [
            SearchAddressInputPresentingModel(didUpdatedInput: didUpdatedInput)
        ]
        output?.showPresentationData(models: models)
        output?.showInitLoadingState()
    }

    func presentAddressResultState(location: GMDetailLocation,
                                   didUpdateInstruction: ((EnterAddressInputType, String) -> Void)?,
                                   confirmAction: (() -> Void)?,
                                   didUpdatedInput: ((String?) -> Void)?) {
        let components = location.address.components(separatedBy: ", ")
        let title = components.first ?? ""
        var subTitle = ""
        for (i, component) in components.enumerated() {
            if i == 0 {
                continue
            }
            subTitle = subTitle + component + (i == components.count - 1 ? "" : ", ")
        }
        let mapModel = EnterAddressMapPresentingModel(
            addressTitle: title,
            addressSubtitle: subTitle,
            latitude: location.latitude ?? 0,
            longitude: location.longitude ?? 0
        )
        let models: [ListDiffable] = [
            SearchAddressInputPresentingModel(didUpdatedInput: didUpdatedInput),
            mapModel,
            EnterAddressInputPresentingModel(inputs: [.apt, .instructions], didUpdateInput: didUpdateInstruction),
            ConfirmActionPresentingModel(isLoading: false, primaryButtonText: "Enter Address", primaryButtonAction: confirmAction)
        ]
        output?.showPresentationData(models: models)
        output?.hideLoadingState()
    }

    func presentChangedAddress() {
        output?.showChangedAddress()
    }

    func dimissModule() {
        output?.dimissModule()
    }
}
