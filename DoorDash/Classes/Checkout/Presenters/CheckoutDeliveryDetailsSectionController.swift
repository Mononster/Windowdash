//
//  CheckoutDeliveryDetailsSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

enum CheckoutDeliveryDetailType: String {
    case address = "Address"
    case map = "map"
    case deliveryInstructions = "Delivery Instructions"
    case eta = "ETA"
}

final class CheckoutDeliveryDetailModel {
    let type: CheckoutDeliveryDetailType
    let title: String
    let subTitle: String
    let lat: Double
    let lng: Double
    let hideSeparator: Bool

    init(type: CheckoutDeliveryDetailType,
         subTitle: String,
         lat: Double = 0,
         lng: Double = 0) {
        self.type = type
        self.title = type.rawValue
        self.subTitle = subTitle
        self.lat = lat
        self.lng = lng
        hideSeparator = type == .deliveryInstructions
    }
}

final class CheckoutDeliveryDetailsPresentingModel: NSObject, ListDiffable {

    let details: [CheckoutDeliveryDetailModel]

    init(details: [CheckoutDeliveryDetailModel]) {
        self.details = details
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class CheckoutDeliveryDetailsSectionController: ListSectionController {

    private var model: CheckoutDeliveryDetailsPresentingModel?

    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        return model?.details.count ?? 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let model = model?.details[safe: index] else {
            return CGSize.zero
        }
        let width = collectionContext?.containerSize.width ?? 0
        let height: CGFloat
        switch model.type {
        case .map:
            height = DeliveryDetailsMapCell.height
        case .address, .deliveryInstructions, .eta:
            height = CheckoutDisplayInfoCell.height
        }
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let model = model?.details[safe: index] else {
            return UICollectionViewCell()
        }
        switch model.type {
        case .map:
            guard let cell = collectionContext?.dequeueReusableCell(of: DeliveryDetailsMapCell.self, for: self, at: index) as? DeliveryDetailsMapCell else {
                fatalError()
            }
            cell.setupCell(lat: model.lat, lng: model.lng)
            return cell
        case .address, .eta, .deliveryInstructions:
            guard let cell = collectionContext?.dequeueReusableCell(of: CheckoutDisplayInfoCell.self, for: self, at: index) as? CheckoutDisplayInfoCell else {
                fatalError()
            }
            cell.setupCell(title: model.title, value: model.subTitle)
            cell.separator.isHidden = model.hideSeparator
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        model = object as? CheckoutDeliveryDetailsPresentingModel
    }

    override func didSelectItem(at index: Int) {

    }
}

extension CheckoutDeliveryDetailsSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerView(atIndex: index)
        default:
            fatalError()
        }
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: CheckoutSectionHeaderCell.height)
    }

    private func headerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: self,
            class: CheckoutSectionHeaderCell.self,
            at: index) as? CheckoutSectionHeaderCell else {
                fatalError()
        }
        cell.setupCell(title: "DELIVERY DETAILS")
        return cell
    }
}
