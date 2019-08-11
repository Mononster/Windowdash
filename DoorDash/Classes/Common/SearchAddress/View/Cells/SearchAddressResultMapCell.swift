//
//  SearchAddressResultMapCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

final class SearchAddressResultMapCell: UICollectionViewCell {

    struct Constants {
        let height: CGFloat = 320
        let mapHeight: CGFloat = 180
        let verticalInset: CGFloat = 22
        let spaceBetweenLabels: CGFloat = 4
        let horizontalInseet: CGFloat = 16
    }

    private let mapView: MKMapView
    private let titleLabel: UILabel
    private let addressLabel: UILabel
    private let secondaryAddressLabel: UILabel
    private let span: MKCoordinateSpan

    private let theme = ApplicationDependency.manager.theme
    private let constants = Constants()

    override init(frame: CGRect) {
        self.mapView = MKMapView()
        self.titleLabel = UILabel()
        self.addressLabel = UILabel()
        self.secondaryAddressLabel = UILabel()
        self.span = MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(lat: Double, lng: Double, address: String, secondaryAddress: String) {
        titleLabel.text = "DELIVERYING TO"
        addressLabel.text = address
        secondaryAddressLabel.text = secondaryAddress
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.region = region

        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.addAnnotation(annotation)
        mapView.layer.cornerRadius = 8
    }
}

extension SearchAddressResultMapCell {

    private func setupUI() {
        setupMapView()
        setupLabel()
        setupAddressLabel()
        setupSecondaryAddressLabel()
        setupConstraints()
    }

    private func setupLabel() {
        addSubview(titleLabel)
        titleLabel.font = theme.fonts.extraBold16
        titleLabel.textColor = theme.colors.black
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.minimumScaleFactor = 0.5
    }

    private func setupAddressLabel() {
        addSubview(addressLabel)
        addressLabel.font = theme.fonts.medium15
        addressLabel.textColor = theme.colors.darkGray
        addressLabel.backgroundColor = .clear
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 1
        addressLabel.minimumScaleFactor = 0.5
    }

    private func setupSecondaryAddressLabel() {
        addSubview(secondaryAddressLabel)
        secondaryAddressLabel.font = theme.fonts.medium15
        secondaryAddressLabel.textColor = theme.colors.darkGray
        secondaryAddressLabel.backgroundColor = .clear
        secondaryAddressLabel.textAlignment = .left
        secondaryAddressLabel.numberOfLines = 1
        secondaryAddressLabel.minimumScaleFactor = 0.5
    }

    private func setupMapView() {
        addSubview(mapView)
        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(constants.horizontalInseet)
            make.top.equalToSuperview().offset(constants.verticalInset)
            make.height.equalTo(constants.mapHeight)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(mapView)
            make.top.equalTo(mapView.snp.bottom).offset(constants.verticalInset)
        }

        addressLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        secondaryAddressLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(addressLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(constants.spaceBetweenLabels)
        }
    }
}

extension SearchAddressResultMapCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "map_pin_annotation"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if view == nil {
            view = StoreMapPinView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        guard let storePinView = view as? StoreMapPinView else { return nil }
        storePinView.imageView.image = theme.imageAssets.houseIcon
        storePinView.imageView.snp.updateConstraints { (make) in
            make.size.equalTo(StoreMapPinView.Constants().selectedImageSize)
        }
        storePinView.displayPriority = .required
        storePinView.annotation = annotation
        storePinView.canShowCallout = false
        return storePinView
    }
}
