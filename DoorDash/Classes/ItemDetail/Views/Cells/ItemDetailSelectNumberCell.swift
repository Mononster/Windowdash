//
//  ItemDetailSelectNumberCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class ItemDetailSelectNumberCell: UICollectionViewCell {

    let adjustQuantityView: AdjustItemQuantityView

    static let height: CGFloat = AdjustItemQuantityView.height + 180

    override init(frame: CGRect) {
        adjustQuantityView = AdjustItemQuantityView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemDetailSelectNumberCell {

    private func setupUI() {
        setupAdjustQuantityView()
        setupConstraints()
    }

    private func setupAdjustQuantityView() {
        addSubview(adjustQuantityView)
    }

    private func setupConstraints() {
        adjustQuantityView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(AdjustItemQuantityView.width)
            make.height.equalTo(AdjustItemQuantityView.height)
        }
    }
}
