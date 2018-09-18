//
//  SignupButtonSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class SignupButtonModel: NSObject, ListDiffable {
    let mode: SignupMode

    init(mode: SignupMode) {
        self.mode = mode
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class SignupButtonSectionController: ListSectionController {

    private var model: SignupButtonModel?

    let buttonTapped: (() -> ())

    init(inset: UIEdgeInsets = .zero, buttonTapped: @escaping (() -> ())) {
        self.buttonTapped = buttonTapped
        super.init()
        self.inset = inset
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: SignupButtonCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SignupButtonCell.self, for: self, at: index) as? SignupButtonCell else {
            fatalError()
        }
        cell.configureCell(action: {
            self.buttonTapped()
        }, mode: model?.mode ?? .login)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SignupButtonModel
    }
}
