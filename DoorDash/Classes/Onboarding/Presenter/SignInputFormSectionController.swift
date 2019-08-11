//
//  SignInputFormSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-17.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class SignInputFormModel: NSObject, ListDiffable {
    let inputs: [SignInputFieldType]

    init(inputs: [SignInputFieldType]) {
        self.inputs = inputs
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class SignInputFormSectionController: ListSectionController {

    private var model: SignInputFormModel?
    static let formLabelWidthRatio: CGFloat = 0.28

    var inputResults: [SignInputFieldType: String] = [:]
    var userFinishInputing: (() -> ())?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: InputFormCell.height)
    }

    override func numberOfItems() -> Int {
        return model?.inputs.count ?? 0
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: InputFormCell.self, for: self, at: index) as? InputFormCell, let type = model?.inputs[safe: index] else {
            fatalError()
        }

        cell.delegate = self
        cell.setupCell(
            type: type,
            nextType: model?.inputs[safe: index + 1],
            isLastInputField: index == (model?.inputs.count ?? 0) - 1
        )
        cell.topSepartor.isHidden = index == 0 ? false : true
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SignInputFormModel
    }
}

extension SignInputFormSectionController: InputFormCellDelegate {

    func updateInputResult(type: SignInputFieldType, value: String) {
        inputResults[type] = value
    }

    func wakeUpInputField(type: SignInputFieldType) {
        for cell in self.collectionContext?.visibleCells(for: self) ?? [] {
            if let cell = cell as? InputFormCell, cell.type == type {
                cell.inputField.becomeFirstResponder()
            }
        }
    }

    func getInputResponder() -> SignInputFieldType? {
        for cell in self.collectionContext?.visibleCells(for: self) ?? [] {
            if let cell = cell as? InputFormCell, cell.inputField.isFirstResponder {
                return cell.type
            }
        }
        return nil
    }

    func completeInputing() {
        self.userFinishInputing?()
    }
}
