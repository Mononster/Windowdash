//
//  RefineAddressMapCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

final class RefineAddressMapCell: UICollectionViewCell {

    private let centerPin: UIImageView
    private let span: MKCoordinateSpan
    let mapView: MKMapView

    override init(frame: CGRect) {
        self.centerPin = UIImageView()
        self.mapView = MKMapView()
        self.span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
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
    }
}

extension RefineAddressMapCell {

    private func setupUI() {
        setupMapView()
        setupCenterPin()
        setupConstraints()
    }

    private func setupMapView() {
        self.addSubview(mapView)
    }

    private func setupCenterPin() {
        self.addSubview(centerPin)
        centerPin.image = ApplicationDependency.manager.theme.imageAssets.mapPinImage
        centerPin.contentMode = .scaleAspectFit
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        centerPin.snp.makeConstraints { (make) in
            make.centerX.equalTo(mapView)
            make.centerY.equalTo(mapView).offset(-20)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
}
