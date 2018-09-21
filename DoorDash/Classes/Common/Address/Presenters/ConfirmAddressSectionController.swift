//
//  ConfirmAddressSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class ConfirmAddressPresentModel: NSObject, ListDiffable {

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

protocol ConfirmAddressSectionControllerDelegate: class {
    func userTappedRefineLocation()
}

final class ConfirmAddressSectionController: ListSectionController {

    private var model: ConfirmAddressPresentModel?
    var dasherInstruction: String?

    weak var delegate: ConfirmAddressSectionControllerDelegate?

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        var height: CGFloat = 0
        if index == 0 {
            height = ConfirmAddressTitleCell.height
        } else if index == 1 {
            height = ConfirmAddressMapCell.height
        } else if index == 2 {
            height = DasherInstructionsInputCell.height
        }
        return CGSize(width: width, height: height)
    }

    override func numberOfItems() -> Int {
        return 3
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ConfirmAddressTitleCell.self, for: self, at: index) as? ConfirmAddressTitleCell, let model = model else {
                fatalError()
            }
            cell.setupCell(title: model.addressTitle, subTitle: model.addressSubtitle)
            return cell
        } else if index == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ConfirmAddressMapCell.self, for: self, at: index) as? ConfirmAddressMapCell, let model = model else {
                fatalError()
            }
            cell.didTapRefineLocation = {
                self.delegate?.userTappedRefineLocation()
            }
            cell.setupCell(lat: model.latitude, lng: model.longitude)
            return cell
        } else if index == 2 {
            guard let cell = collectionContext?.dequeueReusableCell(of: DasherInstructionsInputCell.self, for: self, at: index) as? DasherInstructionsInputCell else {
                fatalError()
            }
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }

    override func didUpdate(to object: Any) {
        model = object as? ConfirmAddressPresentModel
    }
}

extension ConfirmAddressSectionController: DasherInstructionsInputCellDelegate {
    func userUpdatedInput(text: String) {
        if text.isEmpty {
            self.dasherInstruction = nil
        } else {
            self.dasherInstruction = text
        }
    }
}
