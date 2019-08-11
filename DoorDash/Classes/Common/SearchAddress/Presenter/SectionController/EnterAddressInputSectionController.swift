//
//  EnterAddressInputSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class EnterAddressInputPresentingModel: NSObject, ListDiffable {

    let inputs: [EnterAddressInputType]
    let didUpdateInput: ((EnterAddressInputType, String) -> Void)?

    init(inputs: [EnterAddressInputType],
         didUpdateInput: ((EnterAddressInputType, String) -> Void)?) {
        self.inputs = inputs
        self.didUpdateInput = didUpdateInput
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class EnterAddressInputSectionController: BaseSearchAddressSectionController {

    private var model: EnterAddressInputPresentingModel?

    var inputResults: [EnterAddressInputType: String] = [:]
    var userFinishInputing: (() -> ())?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: EnterAddressInputCell.height)
    }

    override func numberOfItems() -> Int {
        return model?.inputs.count ?? 0
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EnterAddressInputCell.self, for: self, at: index) as? EnterAddressInputCell, let type = model?.inputs[safe: index] else {
            fatalError()
        }

        cell.delegate = self
        cell.setupCell(type: type)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? EnterAddressInputPresentingModel
    }
}

extension EnterAddressInputSectionController: EnterAddressInputCellDelegate {

    func updateInputResult(type: EnterAddressInputType, value: String) {
        inputResults[type] = value
        model?.didUpdateInput?(type, value)
    }

    func completeInputing() {
        self.userFinishInputing?()
    }
}
