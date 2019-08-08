//
//  DeliveryDetailsMapCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

final class DeliveryDetailsMapCell: UICollectionViewCell {

    private let mapView: MKMapView
    private let span: MKCoordinateSpan

    static let height: CGFloat = 100

    override init(frame: CGRect) {
        self.mapView = MKMapView()
        self.span = MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(lat: Double, lng: Double) {
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.region = region

        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.addAnnotation(annotation)
    }
}

extension DeliveryDetailsMapCell {

    private func setupUI() {
        setupMapView()
        setupConstraints()
    }

    private func setupMapView() {
        self.addSubview(mapView)
        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
        mapView.layer.cornerRadius = 12
        mapView.layer.masksToBounds = true
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(
                CheckoutViewModel.UIStats.leadingSpace.rawValue
            )
            make.top.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

extension DeliveryDetailsMapCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        return pin
    }
}
