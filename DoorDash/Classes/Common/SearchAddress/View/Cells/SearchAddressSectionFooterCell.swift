//
//  SearchAddressSectionFooterCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class SearchAddressSectionFooterCell: UICollectionViewCell {

    private let bottomSeparator: Separator

    static let height: CGFloat = 10

    override init(frame: CGRect) {
        bottomSeparator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchAddressSectionFooterCell {

    private func setupUI() {
        setupSeparator()
        setupConstraints()
    }

    private func setupSeparator() {
        addSubview(bottomSeparator)
        bottomSeparator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.4)
    }

    private func setupConstraints() {
        bottomSeparator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
