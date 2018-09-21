//
//  ConfirmAddressMapCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

final class ConfirmAddressMapCell: UICollectionViewCell {

    private let mapView: MKMapView
    private let refineLocationLabel: UILabel
    private let mapTopSeparator: Separator
    private let mapBottomSeparator: Separator
    private let span: MKCoordinateSpan

    var didTapRefineLocation: (() -> ())?

    static let height: CGFloat = 120 + 40

    override init(frame: CGRect) {
        self.mapTopSeparator = Separator.create()
        self.mapView = MKMapView()
        self.refineLocationLabel = UILabel()
        self.mapBottomSeparator = Separator.create()
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

extension ConfirmAddressMapCell {

    private func setupUI() {
        setupMapView()
        setupSeparators()
        setupLabel()
        setupConstraints()
    }

    private func setupSeparators() {
        self.addSubview(mapTopSeparator)
        self.addSubview(mapBottomSeparator)
    }

    private func setupLabel() {
        self.addSubview(refineLocationLabel)
        refineLocationLabel.backgroundColor = .clear
        refineLocationLabel.textAlignment = .center
        refineLocationLabel.numberOfLines = 1
        refineLocationLabel.minimumScaleFactor = 0.5
        refineLocationLabel.isUserInteractionEnabled = true
        let regular = Style("regular", {
            $0.font = FontAttribute(font: ApplicationDependency.manager.theme.fontSchema.medium15)
            $0.color = ApplicationDependency.manager.theme.colors.black
            $0.align = .center
        })
        let refineRed = Style("red", {
            $0.font = FontAttribute(font: ApplicationDependency.manager.theme.fontSchema.medium15)
            $0.color = ApplicationDependency.manager.theme.colors.doorDashRed
            $0.align = .center
        })
        refineLocationLabel.attributedText = "Not quite right? ".set(style: regular) + "Refine your location".set(style: refineRed)

        let tap = UITapGestureRecognizer(target: self, action: #selector(userTappedRefineLocation))
        refineLocationLabel.addGestureRecognizer(tap)
    }

    private func setupMapView() {
        self.addSubview(mapView)
        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(120)
        }

        mapTopSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.4)
        }

        mapBottomSeparator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom)
            make.height.equalTo(0.4)
        }

        refineLocationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ConfirmAddressMapCell {

    @objc
    func userTappedRefineLocation() {
        didTapRefineLocation?()
    }
}

extension ConfirmAddressMapCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        return pin
    }
}
