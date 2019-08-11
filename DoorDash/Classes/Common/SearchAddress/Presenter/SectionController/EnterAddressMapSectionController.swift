//
//  EnterAddressMapSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class EnterAddressMapPresentingModel: NSObject, ListDiffable {

    let addressTitle: String
    let addressSubtitle: String
    let latitude: Double
    let longitude: Double

    init(addressTitle: String,
         addressSubtitle: String,
         latitude: Double,
         longitude: Double) {
        self.addressTitle = addressTitle
        self.addressSubtitle = addressSubtitle
        self.latitude = latitude
        self.longitude = longitude
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class EnterAddressMapSectionController: BaseSearchAddressSectionController {

    private var model: EnterAddressMapPresentingModel!

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: SearchAddressResultMapCell.Constants().height)
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SearchAddressResultMapCell.self, for: self, at: index) as? SearchAddressResultMapCell else {
            fatalError()
        }
        cell.setupCell(lat: model.latitude, lng: model.longitude, address: model.addressTitle, secondaryAddress: model.addressSubtitle)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? EnterAddressMapPresentingModel
    }
}
