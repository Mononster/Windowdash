//
//  EnterAddressSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class EnterAddressSectionController: ListSectionController {

    weak var cellDelegate: EnterAddressCellDelegate?
    let viewModel: SelectAddressViewModel

    init(viewModel: SelectAddressViewModel) {
        self.viewModel = viewModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: EnterAddressCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EnterAddressCell.self, for: self, at: index) as? EnterAddressCell else {
            fatalError()
        }
        cell.delegate = cellDelegate
        cell.textField.text = viewModel.userAddress
        return cell
    }
}

