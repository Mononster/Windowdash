//
//  BaseSearchAddressSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import UIKit

class BaseSearchAddressSectionController: ListSectionController, ListSupplementaryViewSource {

    override init() {
        super.init()
        self.supplementaryViewSource = self
    }

    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionFooter]
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            return footerView(atIndex: index)
        default:
            fatalError()
        }
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            return CGSize(width: width, height: SearchAddressSectionFooterCell.height)
        default:
            fatalError()
        }
    }

    func footerView(atIndex index: Int) -> UICollectionReusableView {
        guard let cell = collectionContext?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            for: self,
            class: SearchAddressSectionFooterCell.self,
            at: index) as? SearchAddressSectionFooterCell else {
                fatalError()
        }
        return cell
    }
}
