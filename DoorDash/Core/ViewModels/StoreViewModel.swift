//
//  StoreViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwiftDate

final class StoreViewModel {

    let model: Store
    let costDisplay: String
    let deliveryTimeDisplay: String
    let nameDisplay: String
    let storeDescriptionDisplay: String
    let ratingNumberDisplay: String?
    var ratingDescription: String = ""
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
        costDisplay = store.deliveryFee.cents == 0 ? "Free delivery" : store.deliveryFeeDisplay + " delivery"
        deliveryTimeDisplay = String(store.deliveryMinutes) + " min"
        isClosed = store.nextCloseTime > store.nextOpenTime
        nextOpenDate = DateInRegion(store.nextOpenTime)
        nextCloseDate = DateInRegion(store.nextCloseTime)
        nameDisplay = store.name
        storeDescriptionDisplay = store.storeDescription
        headerImageURL = URL(string: store.headerImageURL ?? "")
        ratingNumberDisplay = store.averageRating == -1 ? nil : String(store.averageRating)
        shouldHighlightRating = store.averageRating >= 4.7
        isNewlyAdded = store.isNewlyAdded
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
            if abs(hours) < 6 {
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
        return deliveryTimeDisplay + " • " + costDisplay
    }
}

extension StoreViewModel {

    func convertToPresenterItem(shouldAddInset: Bool) -> BrowseFoodAllStoreItem{
        let urls = self.menuURLs
        let menuItems = urls.map { url in
            return BrowseFoodAllStoreMenuItem(imageURL: url)
        }
        return BrowseFoodAllStoreItem(
            menuItems: menuItems,
            storeName: nameDisplay,
            priceAndCuisine: storeDescriptionDisplay,
            rating: ratingNumberDisplay,
            ratingDescription: ratingDescription,
            shouldHighlightRating: shouldHighlightRating,
            deliveryTime: isClosed ? openTimeDisplay ?? ""
                : deliveryTimeDisplay,
            deliveryCost: costDisplay,
            isClosed: isClosed,
            shouldAddTopInset: shouldAddInset,
            closeTimeDisplay: closeTimeDisplay)
    }
}
