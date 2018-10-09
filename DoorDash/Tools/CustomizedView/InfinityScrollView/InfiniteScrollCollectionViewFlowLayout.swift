//
//  InfiniteScrollCollectionViewFlowLayout.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-04-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class InfiniteScrollCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
