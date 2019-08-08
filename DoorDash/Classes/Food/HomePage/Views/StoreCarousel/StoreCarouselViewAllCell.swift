//
//  StoreCarouselViewAllCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class StoreCarouselViewAllCell: UICollectionViewCell {

    let viewAllButton: IconedButton

    static let height: CGFloat = 20 + 24 + 20

    override init(frame: CGRect) {
        viewAllButton = IconedButton.button(
            image: ApplicationDependency.manager.theme.imageAssets.rightArrowViewAll,
            imageAlign: .right,
            imageInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoreCarouselViewAllCell {

    private func setupUI() {
        setupViewAllButton()
        setupConstraints()
    }

    private func setupViewAllButton() {
        addSubview(viewAllButton)
        viewAllButton.layer.cornerRadius = 12
        viewAllButton.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        viewAllButton.setTitle("SEE ALL", for: .normal)
        viewAllButton.setTitleColor(ApplicationDependency.manager.theme.colors.white, for: .normal)
        viewAllButton.titleLabel?.font = ApplicationDependency.manager.theme.fonts.bold16
    }

    private func setupConstraints() {
        viewAllButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(24)
        }
    }
}
