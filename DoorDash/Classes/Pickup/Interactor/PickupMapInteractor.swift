//
//  PickupMapInteractor.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit

enum PickupMapMode {
    case list
    case map
}

final class PickupMapInteractor {

    private let presenter: PickupMapPresenter
    private let apiService: BrowseFoodAPIService
    private let storeList: StoreListViewModel
    private var mode: PickupMapMode = .map
    private var mapView: MKMapView?

    private var annotations: [StoreMapPinModel] = []

    init(presenter: PickupMapPresenter, apiService: BrowseFoodAPIService) {
        self.presenter = presenter
        self.apiService = apiService
        self.storeList = StoreListViewModel(service: apiService)
    }

    func linkMapView(mapView: MKMapView) {
        self.mapView = mapView
    }

    func registerAnnotation(_ annotation: StoreMapPinModel) {
        annotations.append(annotation)
    }

    func didTappedOnAnnotation(_ annotation: MKAnnotation) {
        guard let storeAnnotation = annotation as? StoreMapPinModel else { return }
        presenter.presentStoreBannerView(model: storeAnnotation.model)
    }

    func toggleMapMode() {
        mode = mode == .map ? .list : .map
        if mode == .list {
            presenter.presentListView(models: annotations.map { $0.model })
        } else {
            presenter.hideListView()
        }
    }
}

extension PickupMapInteractor {

    func loadData() {
        DoordashLocator.manager.currentPosition(accuracy: .city, onSuccess: { location in
            self.presenter.presentUserLocation(coordinate: location.coordinate)
            self.fetchStoresWithFilter()
        }) { (error, loation) in
            log.error(error)
        }
    }

    func redoSearch() {
        fetchStoresWithFilter {
            self.presenter.mapDidFinishedRefreshing()
        }
    }

    private func fetchStoresWithFilter(completion: (() -> Void)? = nil) {
        guard let mapView = mapView else { return }
        let filters: [StoreFilterRequestModel] = [
            .init(values: ["filter_id": "pickup", "filter_type": "binary"]),
            .init(values: ["filter_id": "sort", "filter_type": "sort", "values": ["Fastest"]])
        ]
        storeList.setFilterOptions(models: filters)
        storeList.fetchStores(location: Location.from(coordinate: mapView.centerCoordinate)) { (errorMsg) in
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                completion?()
                return
            }
            self.clearMap()
            let stores = self.storeList.allStores
            self.presenter.addStoresToMap(stores: stores)
            completion?()
        }
    }

    private func clearMap() {
        guard let mapView = mapView else { return }
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
    }
}
