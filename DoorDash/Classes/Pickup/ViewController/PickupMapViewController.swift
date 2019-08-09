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
        let mapInitialSpan = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let titleViewWidth: CGFloat = 200
        let redoSearchButtonWidth: CGFloat = 160
        let redoButtonTopMargin: CGFloat = 16
        let myLocationButtonSize: CGFloat = 50
        let bannerPadding: CGFloat = 8
    }

    private let interactor: PickupMapInteractor
    private let titleView: PickupMapTitleView
    private let redoSearchButton: RedoSearchButton
    private let myLocationButton: UIButton
    private let mapView: MKMapView
    private let primaryStoreBanner: PickupMapBannerView
    private let secondaryStoreBanner: PickupMapBannerView
    private let constants = Constants()

    weak var delegate: PickupMapViewControllerDelegate?

    init(interactor: PickupMapInteractor) {
        self.interactor = interactor
        self.titleView = PickupMapTitleView()
        self.redoSearchButton = RedoSearchButton()
        self.myLocationButton = UIButton()
        self.mapView = MKMapView()
        self.primaryStoreBanner = PickupMapBannerView()
        self.secondaryStoreBanner = PickupMapBannerView()
        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor.linkMapView(mapView: mapView)
        interactor.loadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let shadowViews: [UIView] = [redoSearchButton, myLocationButton, primaryStoreBanner, secondaryStoreBanner]
        shadowViews.forEach { addShadowToView($0) }
    }

    private func addShadowToView(_ view: UIView) {
        view.addShadow(
            size: CGSize(width: 1, height: 3),
            radius: 3,
            shadowColor: theme.colors.black.withAlphaComponent(0.25),
            shadowOpacity: 0.36,
            viewCornerRadius: 100
        )
    }
}

extension PickupMapViewController {

    private func setupUI() {
        setupMapView()
        setupNavigationBar()
        setupRedoSearchButton()
        setupMyLocationButton()
        setupStoreBannerView()
        setupConstrainst()
    }

    private func setupNavigationBar() {
        let container = CustomNavigationTitleView(
            frame: CGRect(x: 0, y: 0, width: constants.titleViewWidth,height: theme.navigationBarHeight)
        )
        container.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.width.equalTo(constants.titleViewWidth)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(PickupMapTitleView.Constants().height)
        }
        navigationItem.titleView = container
        titleView.setupView(address: "Current Map Area")
    }

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    private func setupStoreBannerView() {
        view.addSubview(primaryStoreBanner)
        primaryStoreBanner.layer.cornerRadius = 8

        view.addSubview(secondaryStoreBanner)
        secondaryStoreBanner.layer.cornerRadius = 8
    }

    private func setupRedoSearchButton() {
        view.addSubview(redoSearchButton)
        redoSearchButton.setTitle("Redo search here", for: .normal)
        redoSearchButton.layer.cornerRadius = RedoSearchButton.Constants().loadingContainerSize / 2
        redoSearchButton.backgroundColor = theme.colors.white
        redoSearchButton.contentHorizontalAlignment = .center
        redoSearchButton.contentVerticalAlignment = .center
        redoSearchButton.setTitleColor(theme.colors.black, for: .normal)
        redoSearchButton.titleLabel?.font = theme.fonts.bold15
        redoSearchButton.addTarget(self, action: #selector(redoSearchButtonTapped), for: .touchUpInside)
    }

    private func setupMyLocationButton() {
        view.addSubview(myLocationButton)
        myLocationButton.setImage(theme.imageAssets.myLocationImage, for: .normal)
        myLocationButton.backgroundColor = theme.colors.white
        myLocationButton.contentHorizontalAlignment = .center
        myLocationButton.contentVerticalAlignment = .center
        myLocationButton.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        myLocationButton.layer.cornerRadius = constants.myLocationButtonSize / 2
    }

    private func setupConstrainst() {
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        redoSearchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(RedoSearchButton.Constants().loadingContainerSize)
            make.width.equalTo(constants.redoSearchButtonWidth)
        }

        myLocationButton.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview().inset(8)
            make.size.equalTo(constants.myLocationButtonSize)
        }

        primaryStoreBanner.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(constants.bannerPadding)
            make.top.equalTo(view.snp.bottom).offset(8)
        }

        secondaryStoreBanner.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.leading.trailing.equalToSuperview().inset(constants.bannerPadding)
            make.top.equalTo(view.snp.bottom).offset(8)
        }
    }
}

extension PickupMapViewController: PickupMapPresenterOutput {

    func showMapLoadingAnimation() {
        
    }

    func showUserLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: constants.mapInitialSpan)
        mapView.region = region
    }

    func presentStoreMarkerOnMap(model: StoreMapPinModel) {
        mapView.addAnnotation(model)
    }

    func showMapFinishedRefresh() {
        redoSearchFinished()
    }

    func showStoreBannerView(model: StoreViewModel) {
        guard let storeBanner = pickBannerToShow() else { return }
        storeBanner.configData(viewModel: model)
        storeBanner.viewState = .presenting
        let bannerHeight = PickupMapBannerView.calcHeight(viewModel: model)
        storeBanner.snp.updateConstraints { make in
            make.height.equalTo(bannerHeight)
            make.top.equalTo(self.view.snp.bottom).offset(-bannerHeight - 12)
        }
        storeBanner.isHidden = false
        UIView.animate(withDuration: DefaultAnimator.duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            storeBanner.viewState = .present
        })
    }

    func hideStoreBannerView() {
        guard let storeBanner = pickBannerToHide() else { return }
        storeBanner.snp.updateConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(8)
        }
        storeBanner.viewState = .dismissing
        UIView.animate(withDuration: DefaultAnimator.duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            storeBanner.viewState = .hidden
            storeBanner.isHidden = true
        })
    }
}

extension PickupMapViewController {

    private func pickBannerToShow() -> PickupMapBannerView? {
        if primaryStoreBanner.viewState == .hidden {
            return primaryStoreBanner
        }
        if secondaryStoreBanner.viewState == .hidden {
            return secondaryStoreBanner
        }
        return nil
    }

    private func pickBannerToHide() -> PickupMapBannerView? {
        if primaryStoreBanner.viewState == .present {
            return primaryStoreBanner
        }
        if secondaryStoreBanner.viewState == .present {
            return secondaryStoreBanner
        }
        return nil
    }

    private func startRedoSearch() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        redoSearchButton.prepareToAnimate()
        redoSearchButton.snp.updateConstraints { (make) in
            make.width.equalTo(RedoSearchButton.Constants().loadingContainerSize)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.redoSearchButton.startAnimation()
        })
        interactor.redoSearch()
    }

    private func redoSearchFinished() {
        redoSearchButton.stopAnimation()
        redoSearchButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(-RedoSearchButton.Constants().loadingContainerSize)
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.redoSearchButton.isHidden = true
            self.redoSearchButton.setOriginalState()
            self.redoSearchButton.snp.updateConstraints { (make) in
                make.width.equalTo(self.constants.redoSearchButtonWidth)
            }
        })
    }
}

extension PickupMapViewController: MKMapViewDelegate {

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard redoSearchButton.isHidden else { return }
        redoSearchButton.isHidden = false
        redoSearchButton.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(self.constants.redoButtonTopMargin)
        }
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        })
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StoreMapPinModel else { return nil }
        interactor.registerAnnotation(annotation)
        let reuseIdentifier = "map_pin_annotation"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if view == nil {
            view = StoreMapPinView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        guard let storePinView = view as? StoreMapPinView else { return nil }
        storePinView.setupView(title: annotation.title ?? "")
        view?.displayPriority = .required
        view?.annotation = annotation
        view?.canShowCallout = false
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        interactor.didTappedOnAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideStoreBannerView()
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        var i = -1
        for view in views {
            guard let annotation = view.annotation else { continue }
            i += 1
            let point: MKMapPoint = MKMapPoint(annotation.coordinate);
            if !mapView.visibleMapRect.contains(point) {
                continue
            }
            view.alpha = 0
            let delay = 0.005 * Double(i)
            UIView.animate(withDuration: 0.1, delay: delay, options: .curveEaseIn, animations: {
                view.alpha = 1
            })
        }
    }
}

extension PickupMapViewController {

    @objc
    private func redoSearchButtonTapped() {
        startRedoSearch()
    }

    @objc
    private func myLocationButtonTapped() {
        DoordashLocator.manager.currentPosition(accuracy: .city, onSuccess: { location in
            self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: self.mapView.region.span), animated: true)
        }) { (error, loation) in
            log.error(error)
        }
    }
}
