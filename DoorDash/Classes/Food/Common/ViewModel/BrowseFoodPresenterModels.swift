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
    let storeID: String
    let menuItems: [BrowseFoodAllStoreMenuItem]
    let storeName: String
    let priceAndCuisine: String
    let rating: String?
    let ratingDescription: String
    let shouldHighlightRating: Bool
    let deliveryTime: String
    let deliveryCost: String
    let shouldAddTopInset: Bool
    let layout: MenuCollectionViewLayoutKind
    var closeTimeDisplay: String?
    let isClosed: Bool
    var currentScrollOffset: CGPoint?

    init(storeID: String,
         menuItems: [BrowseFoodAllStoreMenuItem],
         storeName: String,
         priceAndCuisine: String,
         rating: String?,
         ratingDescription: String,
         shouldHighlightRating: Bool,
         deliveryTime: String,
         deliveryCost: String,
         isClosed: Bool,
         layout: MenuCollectionViewLayoutKind = .centerOneItem,
         shouldAddTopInset: Bool = true,
         closeTimeDisplay: String? = nil) {
        self.storeID = storeID
        self.menuItems = menuItems
        self.storeName = storeName
        self.priceAndCuisine = priceAndCuisine
        self.rating = rating
        self.ratingDescription = ratingDescription
        self.shouldHighlightRating = shouldHighlightRating
        self.deliveryTime = deliveryTime
        self.deliveryCost = deliveryCost
        self.isClosed = isClosed
        self.layout = layout
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
    let showSeparator: Bool

    init(title: String, showSeparator: Bool) {
        self.title = title
        self.showSeparator = showSeparator
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

