//
//  PickupMapPresenter.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

protocol PickupMapPresenterOutput: class {
    func showMapLoadingAnimation()
}

protocol PickupMapPresenterType: class {
    func presentMapLoading()
    func mapDidFinishedLoading()
}

final class PickupMapPresenter: PickupMapPresenterType {

    weak var output: PickupMapPresenterOutput?

    func presentMapLoading() {
        output?.showMapLoadingAnimation()
    }

    func mapDidFinishedLoading() {
    }
}

