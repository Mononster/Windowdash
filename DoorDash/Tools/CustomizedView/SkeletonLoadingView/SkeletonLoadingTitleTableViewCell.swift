//
//  SkeletonLoadingTitleTableViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class SkeletonLoadingTitleTableViewCell: UITableViewCell {

    let defaultImageView: UIImageView
    let label: UILabel

    static let height: CGFloat = 250
    static let identifier: String = "SkeletonLoadingTitleTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        defaultImageView = UIImageView()
        label = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SkeletonLoadingTitleTableViewCell {

    private func setupUI() {
        setupLabel()
        setupImageView()
        setupConstraints()
    }

    private func setupLabel() {
        contentView.addSubview(label)
        label.text = "Text"
        label.isSkeletonable = true
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.font = ApplicationDependency.manager.theme.fonts.heavy18
    }

    private func setupImageView() {
        contentView.addSubview(defaultImageView)
        defaultImageView.isSkeletonable = true
        defaultImageView.image = ApplicationDependency.manager.theme.imageAssets.grayRectBackground
    }

    private func setupConstraints() {
        defaultImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(label)
            make.bottom.equalTo(label.snp.top).offset(-12)
        }

        label.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(60)
        }
    }
}
