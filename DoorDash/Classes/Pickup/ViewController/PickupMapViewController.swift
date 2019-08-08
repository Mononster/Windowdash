//
//  PickupMapViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import MapKit

protocol PickupMapViewControllerDelegate: class {

}

final class PickupMapViewController: BaseViewController {

    struct Constants {
        let mapInitialSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    }

    private let interactor: PickupMapInteractor
    private let mapView: MKMapView
    private let constants = Constants()

    weak var delegate: PickupMapViewControllerDelegate?

    init(interactor: PickupMapInteractor) {
        self.interactor = interactor
        self.mapView = MKMapView()
        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PickupMapViewController {

    private func setupUI() {
        setupMapView()
        setupConstrainst()
    }

    private func setupMapView() {
        view.addSubview(mapView)

    }

    private func setupConstrainst() {
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension PickupMapViewController: PickupMapPresenterOutput {

    func showMapLoadingAnimation() {
        
    }
}
