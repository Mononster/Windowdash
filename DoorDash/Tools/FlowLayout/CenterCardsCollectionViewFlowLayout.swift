//
//  CenterCardsCollectionViewFlowLayout.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class CenterCardsCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var mostRecentOffset = CGPoint()
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {

        // if no horizontal scroll, return the most recent one
        if velocity.x == 0 {
            return mostRecentOffset
        }
        if let cv = self.collectionView {
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                        continue
                    }
                    let scrollInvalid = attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0
                    if attributes.center.x == 0 || scrollInvalid {
                        continue
                    }
                    candidateAttributes = attributes
                }
                if proposedContentOffset.x == -(cv.contentInset.left) {
                    return proposedContentOffset
                }

                guard let _ = candidateAttributes else {
                    return mostRecentOffset
                }

                mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
                return mostRecentOffset
            }
        }
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

