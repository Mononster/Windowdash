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

    var buttonTapped: (() -> ())?

    override init() {
        super.init()
        self.inset = .init(top: 12, left: 0, bottom: 0, right: 0)
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
            self.buttonTapped?()
        }, mode: model?.mode ?? .login)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SignupButtonModel
    }

    func stopAnimating() {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? SignupButtonCell else {
            return
        }
        cell.stopAnimation()
    }

    func startAnimating() {
        guard let cell = collectionContext?.cellForItem(at: 0, sectionController: self) as? SignupButtonCell else {
            return
        }
        cell.startAnimaton()
    }
}
