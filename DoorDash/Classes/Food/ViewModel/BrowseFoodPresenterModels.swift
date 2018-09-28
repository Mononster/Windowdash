//
//  BrowseFoodPresenterModels.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class BrowseFoodAllStoreMenuItem: NSObject, ListDiffable {

    let imageURL: URL

    init(imageURL: URL) {
        self.imageURL = imageURL
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class BrowseFoodAllStoreItem: NSObject, ListDiffable {
    let menuItems: [BrowseFoodAllStoreMenuItem]
    let storeName: String
    let priceAndCuisine: String
    let rating: String?
    let ratingDescription: String
    let shouldHighlightRating: Bool
    let deliveryTime: String
    let deliveryCost: String
    let shouldAddTopInset: Bool
    var closeTimeDisplay: String?
    let isClosed: Bool

    init(menuItems: [BrowseFoodAllStoreMenuItem],
         storeName: String,
         priceAndCuisine: String,
         rating: String?,
         ratingDescription: String,
         shouldHighlightRating: Bool,
         deliveryTime: String,
         deliveryCost: String,
         isClosed: Bool,
         shouldAddTopInset: Bool = true,
         closeTimeDisplay: String? = nil) {
        self.menuItems = menuItems
        self.storeName = storeName
        self.priceAndCuisine = priceAndCuisine
        self.rating = rating
        self.ratingDescription = ratingDescription
        self.shouldHighlightRating = shouldHighlightRating
        self.deliveryTime = deliveryTime
        self.deliveryCost = deliveryCost
        self.isClosed = isClosed
        self.shouldAddTopInset = shouldAddTopInset
        self.closeTimeDisplay = closeTimeDisplay
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class BrowseFoodAllStoreItems: NSObject, ListDiffable {
    var items: [BrowseFoodAllStoreItem]

    init(items: [BrowseFoodAllStoreItem]) {
        self.items = items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class BrowseFoodAllStoreHeaderModel: NSObject, ListDiffable {

    let title: String

    init(title: String) {
        self.title = title
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

