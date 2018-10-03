//
//  StoreDetailMenuNavigatorCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-01.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreDetailMenuNavigatorCell: UICollectionViewCell {

    let segmentNavigateView: SegmentNavigateView

    static let height: CGFloat = 45

    override init(frame: CGRect) {
        segmentNavigateView = SegmentNavigateView(
            frame: CGRect(
                x: 0, y: 0,
                width: UIScreen.main.bounds.width,
                height: 45
            )
        )
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(navigatorTitles: [String]) {
        self.segmentNavigateView.setTitles(titles: navigatorTitles)
    }
}

extension StoreDetailMenuNavigatorCell {

    private func setupUI() {
        self.backgroundColor = .clear//ApplicationDependency.manager.theme.colors.white
        addSubview(segmentNavigateView)
        segmentNavigateView.backgroundColor = .clear //ApplicationDependency.manager.theme.colors.white
    }
}
