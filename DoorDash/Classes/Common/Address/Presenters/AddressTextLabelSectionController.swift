//
//  AddressTextLabelSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class AddressTextLabelSectionController: ListSectionController {

    static let cellHeight: CGFloat = 42
    private var predictions: [GMPrediction] = []

    var cellTapped: ((GMPrediction) -> ())?

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: AddressTextLabelSectionController.cellHeight)
    }

    override func numberOfItems() -> Int {
        return predictions.count
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AddressTextLabelCell.self, for: self, at: index) as? AddressTextLabelCell else {
            fatalError()
        }
        cell.text = predictions[index].address
        cell.separator.isHidden = index == predictions.count - 1
        return cell
    }

    override func didUpdate(to object: Any) {
        predictions = (object as? QueriedAddresses)?.predictions ?? []
    }

    override func didSelectItem(at index: Int) {
        cellTapped?(predictions[index])
    }
}

