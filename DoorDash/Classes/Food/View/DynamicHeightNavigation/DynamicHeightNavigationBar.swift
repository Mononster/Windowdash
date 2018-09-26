//
//  DynamicHeightNavigationBar.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

final class DynamicHeightNavigationBar: UIView {

    let addressView: NavigationAddressHeaderView
    let titleLabel: UILabel
    let filterLabel: UILabel

    private let separator: Separator
    private var originFrame: CGRect
    private var originTitleLabelFrame: CGRect

    override init(frame: CGRect) {
        addressView = NavigationAddressHeaderView()
        originTitleLabelFrame = CGRect(x: 24, y: UIDevice.current.verticalPadding + 18,
                                       width: frame.width / 3, height: (frame.height - 24) / 2)
        titleLabel = UILabel(frame: originTitleLabelFrame)
        let filterLabelWidth = frame.width / 3.5
        let filterLabelFrame = CGRect(x: frame.width - 24 - filterLabelWidth,
                                      y: UIDevice.current.verticalPadding + 16,
                                      width:filterLabelWidth, height: (frame.height - 24) / 2)
        filterLabel = UILabel(frame: filterLabelFrame)
        separator = Separator.create()
        originFrame = frame
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBy(offset: CGFloat) {
        let navBarHeight = ApplicationDependency.manager.theme.navigationBarHeight
        self.frame = CGRect(
            x: originFrame.minX,
            y: originFrame.minY - offset,
            width: originFrame.width,
            height: originFrame.height
        )

        let filterOffsetMax: CGFloat = 8
        self.filterLabel.transform = CGAffineTransform(
            translationX: 0,
            y: (1 - offset / navBarHeight / filterOffsetMax) * offset
        )

        self.addressView.layer.opacity = Float(1 - offset / (navBarHeight - 10))
        print(offset / navBarHeight / filterOffsetMax)
        let scale = 0.35 - offset / originFrame.height
        self.titleLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            .scaledBy(x: max(0.65, scale + 0.65), y: max(0.65, scale + 0.65))
        print("scale == \(scale)")
    }

    func adjustBySrollView(offsetY: CGFloat,
                           previousOffset: CGFloat,
                           navigattionBarMinHeight: CGFloat) {
        if offsetY <= navigattionBarMinHeight && offsetY > 0 {
            self.updateBy(offset: offsetY)
        }
        if previousOffset < navigattionBarMinHeight && offsetY >= navigattionBarMinHeight {
            self.updateBy(offset: navigattionBarMinHeight)
        }
        if previousOffset > 0 && offsetY < 0 {
            self.updateBy(offset: 0)
        }
        if offsetY < 0 {
            let scale = 0 - offsetY / (originFrame.height * 4)
            self.titleLabel.transform = CGAffineTransform(scaleX: min(1.35, scale + 1),
                                                          y: min(1.35, scale + 1))
        }
    }
}

extension DynamicHeightNavigationBar {

    private func setupUI() {
        addSubview(separator)
        separator.alpha = 0.6
        setupTitleLabel()
        setupAddressView()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = ApplicationDependency.manager.theme.colors.black
        titleLabel.font = ApplicationDependency.manager.theme.fontSchema.bold30
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.text = "Browse"
        titleLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
        titleLabel.frame = originTitleLabelFrame

        addSubview(filterLabel)
        filterLabel.textColor = ApplicationDependency.manager.theme.colors.doorDashRed
        filterLabel.font = ApplicationDependency.manager.theme.fontSchema.medium18
        filterLabel.adjustsFontSizeToFitWidth = true
        filterLabel.textAlignment = .right
        filterLabel.minimumScaleFactor = 0.5
        filterLabel.numberOfLines = 1
        filterLabel.text = "Filter"
    }

    private func setupAddressView() {
        addSubview(addressView)
        addressView.backgroundColor = .clear
    }

    private func setupConstraints() {
        addressView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalToSuperview().multipliedBy(0.33)
            make.height.equalToSuperview().offset(-12).multipliedBy(0.5)
        }

        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(
                BrowseFoodViewModel.UIConfigure.homePageLeadingSpace
            )
            make.height.equalTo(0.6)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
