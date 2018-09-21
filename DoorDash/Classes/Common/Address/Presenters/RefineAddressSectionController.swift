//
//  RefineAddressSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class RefineAddressSectionController: ListSectionController {
    private var model: ConfirmAddressPresentModel?
    private let topEdge: CGFloat = 16

    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: topEdge, left: 0, bottom: 0, right: 0)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let collectionViewHeight = collectionContext?.containerSize.height ?? 0
        var height: CGFloat = 0
        if index == 0 {
            height = RefineLocationTitleCell.height
        } else if index == 1 {
            height = ConfirmAddressTitleCell.height
        } else if index == 2 {
            height = collectionViewHeight - RefineLocationTitleCell.height - ConfirmAddressTitleCell.height - topEdge
        }
        return CGSize(width: width, height: height)
    }

    override func numberOfItems() -> Int {
        return 3
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: RefineLocationTitleCell.self, for: self, at: index) as? RefineLocationTitleCell else {
                fatalError()
            }
            return cell
        } else if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ConfirmAddressTitleCell.self, for: self, at: index) as? ConfirmAddressTitleCell, let model = model else {
                fatalError()
            }
            cell.setupCell(title: model.addressTitle, subTitle: model.addressSubtitle)
            return cell
        } else if index == 2 {
            guard let cell = collectionContext?.dequeueReusableCell(of: RefineAddressMapCell.self, for: self, at: index) as? RefineAddressMapCell, let model = model else {
                fatalError()
            }
            cell.setupCell(lat: model.latitude, lng: model.longitude)
            return cell
        }
        return UICollectionViewCell()
    }

    override func didUpdate(to object: Any) {
        model = object as? ConfirmAddressPresentModel
    }

    func getCurrentMapCenter() -> (Double, Double)? {
        guard let cell = collectionContext?.cellForItem(at: 2, sectionController: self) as? RefineAddressMapCell else {
            return nil
        }
        return (cell.mapView.centerCoordinate.latitude, cell.mapView.centerCoordinate.longitude)
    }
}
