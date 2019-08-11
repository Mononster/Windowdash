//
//  StoreViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwiftDate

enum BannerViewMode {
    case pickup
    case delivery
}

final class StoreViewModel {

    let model: Store
    let costDisplayLong: String
    let costDisplayShort: String
    let distanceFromConsumer: String
    let deliveryTimeDisplay: String
    let nameDisplay: String
    let businessNameDisplay: String
    let storeDescriptionDisplay: String
    let ratingNumberDisplay: String?
    var ratingDescription: String = ""
    let ratingPreciseDescription: String
    let priceRangeDisplay: String
    let isNewlyAdded: Bool
    let shouldHighlightRating: Bool

    let isClosed: Bool
    var nextOpenTimeDisplay: String?
    var closeTimeDisplay: String?
    var openTimeDisplay: String?
    var nextOpenDate: DateInRegion
    var nextCloseDate: DateInRegion
    var menuURLs: [URL] = []
    let headerImageURL: URL?

    init(store: Store) {
        self.model = store
        costDisplayLong = store.deliveryFee.cents == 0 ? "Free delivery" : store.deliveryFeeDisplay + " delivery"
        costDisplayShort = store.deliveryFee.cents == 0 ? "Free" : store.deliveryFeeDisplay
        deliveryTimeDisplay = String(store.deliveryMinutes) + " min"
        isClosed = store.nextCloseTime > store.nextOpenTime
        nextOpenDate = DateInRegion(store.nextOpenTime)
        nextCloseDate = DateInRegion(store.nextCloseTime)
        nameDisplay = store.name
        businessNameDisplay = store.businessName
        headerImageURL = URL(string: store.headerImageURL ?? "")
        ratingNumberDisplay = store.averageRating == -1 ? nil : String(store.averageRating)
        shouldHighlightRating = store.averageRating >= 4.7
        isNewlyAdded = store.isNewlyAdded
        ratingPreciseDescription = (ratingNumberDisplay ?? "") + " (\(store.numRatings) ratings)"
        if let distance = store.distanceFromConsumer {
            distanceFromConsumer = String(format: "%.1f", distance.displayValue)
        } else {
            distanceFromConsumer = "N/A"
        }
        var tempPriceRange = ""
        for _ in 0..<store.priceRange {
            tempPriceRange += "$"
        }
        priceRangeDisplay = tempPriceRange + " •"
        storeDescriptionDisplay = priceRangeDisplay + " " + store.storeDescription
        setup()
    }

    private func setup() {
        setMenuURLs()
        setupTimeDisplay()
        setupRatingDescription()
    }

    private func setupTimeDisplay() {
        nextCloseDate.customFormatter = Date.amPmFormatter
        nextOpenDate.customFormatter = Date.amPmFormatter
        if !isClosed {
            // check time interval between current time and close time
            let hours = Date().hours(from: model.nextCloseTime)
            if abs(hours) < 1 {
                // less than 1 hour to close the store, add close time display
                let closeTime = nextCloseDate.toFormat("hh:mm a")
                closeTimeDisplay = "CLOSES AT " + closeTime
            }
        } else {
            closeTimeDisplay = "CURRENTLY CLOSED"
            // set up next open time
            let openTime = nextOpenDate.toFormat("hh:mm a")
            let openWeekday = nextOpenDate.weekdayName(.short)
            openTimeDisplay = "Opens \(openWeekday) at " + openTime
        }
    }

    private func setupRatingDescription() {
        if isNewlyAdded {
            ratingDescription = "Newly Added"
        } else {
            if model.numRatings < 1000 {
                ratingDescription = String(model.numRatings) + " ratings"
            } else {
                let numOf500Ratings = model.numRatings / 500
                ratingDescription = String(numOf500Ratings * 500) + "+ ratings"
            }
        }
    }

    private func setMenuURLs() {
        guard let menus = model.menus, menus.count > 0 else {
            return
        }
        for menu in menus {
            if let items = menu.items {
                for item in items {
                    if let urlString = item.url, let url = URL(string: urlString) {
                        menuURLs.append(url)
                    }
                }
            }
        }
    }

    func getDeliveryTimeAndCostCombineString() -> String {
        return deliveryTimeDisplay + " • " + costDisplayLong
    }

    private func locationFromUser() -> String {
        guard let storeLocation = model.location,
            let userLocation = DoordashLocator.manager.userLastLocation else {
            return ""
        }
        return storeLocation.distance(from: userLocation).calculatedDistance
    }
}

extension StoreViewModel {

    func convertToPresenterItem(topInset: CGFloat? = nil,
                                mode: BannerViewMode = .delivery,
                                layout: MenuCollectionViewLayoutKind) -> BrowseFoodAllStoreItem{
        let urls = self.menuURLs
        let storeConstants = SingleStoreSectionController.Constants()
        var menuItems = urls.map { url in
            return BrowseFoodAllStoreMenuItem(imageURL: url)
        }
        if mode == .pickup && menuItems.count >= 2 {
            menuItems = Array(menuItems.prefix(upTo: 2))
        }
        return BrowseFoodAllStoreItem(
            storeID: String(model.id),
            menuItems: menuItems,
            storeName: nameDisplay,
            priceAndCuisine: storeDescriptionDisplay,
            rating: ratingNumberDisplay,
            ratingDescription: ratingDescription,
            shouldHighlightRating: shouldHighlightRating,
            deliveryTime: isClosed ? openTimeDisplay ?? ""
                : deliveryTimeDisplay,
            deliveryCost: mode == .pickup ? locationFromUser() : costDisplayLong,
            isClosed: isClosed,
            layout: layout,
            topInset: topInset ?? (menuURLs.count > 0 ? storeConstants.topInsetWithImage : storeConstants.topInsetWithoutImage),
            closeTimeDisplay: closeTimeDisplay,
            bannerDisplayMode: mode)
    }
}
