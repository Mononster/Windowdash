//
//  OnboardingItemSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class OnboardingItem: NSObject, ListDiffable {
    
    let image: UIImage
    let title: String
    let subTitle: String

    init(image: UIImage, title: String, description: String) {
        self.image = image
        self.title = title
        self.subTitle = description
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class OnboardingItems: NSObject, ListDiffable {

    let items: [OnboardingItem]

    init(items: [OnboardingItem]) {
        self.items = items
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class OnboardingItemSectionController: ListSectionController {

    private var onboardingItem: OnboardingItem?

    override init() {
        super.init()
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: OnboardingItemCell.self, for: self, at: index) as? OnboardingItemCell, let item = onboardingItem else {
            fatalError()
        }
        cell.setupCell(image: item.image, title: item.title, subTitle: item.subTitle)
        return cell
    }

    override func didUpdate(to object: Any) {
        onboardingItem = object as? OnboardingItem
    }
}
