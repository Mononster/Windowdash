//
//  PickupMapPresenter.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit

protocol PickupMapPresenterOutput: class {
    func showMapLoadingAnimation()
    func showMapFinishedRefresh()
    func showUserLocation(coordinate: CLLocationCoordinate2D)
    func presentStoreMarkerOnMap(model: StoreMapPinModel)
    func showStoreBannerView(model: StoreViewModel)
    func hideStoreBannerView()
}

protocol PickupMapPresenterType: class {
    func presentMapLoading()
    func presentUserLocation(coordinate: CLLocationCoordinate2D)
    func mapDidFinishedLoading()
    func mapDidFinishedRefreshing()
    func presentStoreBannerView(model: StoreViewModel)
    func hideStoreBannerView()
}

final class PickupMapPresenter: PickupMapPresenterType {

    weak var output: PickupMapPresenterOutput?

    func presentMapLoading() {
        output?.showMapLoadingAnimation()
    }

    func mapDidFinishedLoading() {
    }

    func presentUserLocation(coordinate: CLLocationCoordinate2D) {
        output?.showUserLocation(coordinate: coordinate)
    }

    func mapDidFinishedRefreshing() {
        output?.showMapFinishedRefresh()
    }

    func addStoresToMap(stores: [StoreViewModel]) {
        stores.forEach { addStoreToMap(store: $0) }
    }

    func presentStoreBannerView(model: StoreViewModel) {
        output?.showStoreBannerView(model: model)
    }

    func hideStoreBannerView() {
        output?.hideStoreBannerView()
    }

    private func addStoreToMap(store: StoreViewModel) {
        guard let location = store.model.location else { return }
        output?.presentStoreMarkerOnMap(model: StoreMapPinModel(coordinate: location.coordinate, title: store.nameDisplay, model: store))
    }
}

