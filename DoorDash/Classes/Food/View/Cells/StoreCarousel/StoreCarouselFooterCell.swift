//
//  StoreCarouselFooterCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-26.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class StoreCarouselFooterCell: UICollectionViewCell {

    let viewAllButton: IconedButton
    private let separator: Separator
    static let height: CGFloat = 20 + 30 + 20 + 16

    override init(frame: CGRect) {
        separator = Separator.create()
        viewAllButton = IconedButton.button(
            image: ApplicationDependency.manager.theme.imageAssets.rightArrowViewAll,
            imageAlign: .right,
            imageInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoreCarouselFooterCell {

    private func setupUI() {
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
        setupSeparator()
        setupViewAllButton()
        setupConstraints()
    }

    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.4)
    }

    private func setupViewAllButton() {
        addSubview(viewAllButton)
        viewAllButton.layer.cornerRadius = 15
        viewAllButton.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        viewAllButton.setTitle("SEE ALL", for: .normal)
        viewAllButton.setTitleColor(ApplicationDependency.manager.theme.colors.white, for: .normal)
        viewAllButton.contentHorizontalAlignment = .left
        viewAllButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        viewAllButton.titleLabel?.font = ApplicationDependency.manager.theme.fontSchema.bold14
    }

    private func setupConstraints() {
        viewAllButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(viewAllButton.snp.bottom).offset(16)
        }
    }
}
