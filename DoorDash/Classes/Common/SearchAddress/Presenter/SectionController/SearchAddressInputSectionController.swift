//
//  SearchAddressInputSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit

final class SearchAddressInputPresentingModel: NSObject, ListDiffable {

    let id: Int = 0
    let didUpdatedInput: ((String?) -> Void)?

    init(didUpdatedInput: ((String?) -> Void)?) {
        self.didUpdatedInput = didUpdatedInput
    }

    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SearchAddressInputPresentingModel else { return false }
        return id == object.id
    }
}

final class SearchAddressInputSectionController: BaseSearchAddressSectionController {

    private var model: SearchAddressInputPresentingModel!

    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = SearchAddressInputCell.Constants().height
        return CGSize(width: width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SearchAddressInputCell.self, for: self, at: index) as? SearchAddressInputCell else {
            fatalError()
        }
        cell.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SearchAddressInputPresentingModel
    }

    func updateInputText(_ text: String) {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? SearchAddressInputCell else {
            return
        }
        cell.searchTextField.text = text
    }

    func wakeUpInput() {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? SearchAddressInputCell else {
            return
        }
        cell.searchTextField.becomeFirstResponder()
    }
}

extension SearchAddressInputSectionController {

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        model.didUpdatedInput?(textField.text)
    }
}
