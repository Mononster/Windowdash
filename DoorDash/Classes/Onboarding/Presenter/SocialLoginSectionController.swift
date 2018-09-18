//
//  SocialLoginSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-17.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import IGListKit

final class SocialLoginSectionController: ListSectionController {

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: CGFloat(LoginComponentView.height))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SocialLoginCell.self, for: self, at: index) as? SocialLoginCell else {
            fatalError()
        }
        return cell
    }

}
