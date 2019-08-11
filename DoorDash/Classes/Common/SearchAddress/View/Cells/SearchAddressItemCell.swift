//
//  SearchAddressItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

private let theme = ApplicationDependency.manager.theme

final class SearchAddressItemCell: UICollectionViewCell {

    struct Constants {
        let titleFont: UIFont = theme.fonts.medium15
        let titleNormalColor: UIColor = theme.colors.black
        let subTitleNormalColor: UIColor = theme.colors.darkGray
        let descriptionNormalColor: UIColor = theme.colors.gray
        let subTitleNormalFont: UIFont = theme.fonts.medium14
        let descriptionNormalFont: UIFont = theme.fonts.medium12
        let addressImageViewSize: CGFloat = 24
        let selectedImageViewSize: CGFloat = 16
        let loadingIndicatorSize: CGFloat = 16
        let horizontalInset: CGFloat = 16
        let verticalInset: CGFloat = 12
        let spaceBetweenLabels: CGFloat = 2
    }

    private let titleLabel: UILabel
    private let subTitle: UILabel
    private let descriptionLabel: UILabel
    private let addressImageView: UIImageView
    private let selectedImageView: UIImageView
    private let loadingIndicator: NVActivityIndicatorView

    private let constants = Constants()

    override init(frame: CGRect) {
        titleLabel = UILabel()
        subTitle = UILabel()
        descriptionLabel = UILabel()
        addressImageView = UIImageView()
        selectedImageView = UIImageView()
        loadingIndicator = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: ApplicationDependency.manager.theme.colors.doorDashRed, lineWidth: 2)
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(title: String, subText: String, description: String?, selected: Bool) {
        titleLabel.text = title
        subTitle.text = subText
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
        selectedImageView.isHidden = !selected
        if selected {
            titleLabel.textColor = theme.colors.doorDashRed
            subTitle.textColor = theme.colors.doorDashRed
            descriptionLabel.textColor = theme.colors.doorDashRed
            subTitle.font = constants.titleFont
            descriptionLabel.font = constants.titleFont
            addressImageView.setImageColor(color: theme.colors.doorDashRed)
        } else {
            titleLabel.textColor = constants.titleNormalColor
            descriptionLabel.textColor = constants.descriptionNormalColor
            descriptionLabel.font = constants.descriptionNormalFont
            subTitle.font = constants.subTitleNormalFont
            subTitle.textColor = constants.subTitleNormalColor
            addressImageView.setImageColor(color: constants.descriptionNormalColor)
        }
    }

    func startAnimation() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }

    func stopAnimation() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }

    static func calcHeight(containerWidth: CGFloat,
                           title: String,
                           subText: String,
                           description: String?,
                           selected: Bool) -> CGFloat {
        let constants = SearchAddressItemCell.Constants()
        let labelContainerWidth: CGFloat = containerWidth - constants.horizontalInset - constants.addressImageViewSize - constants.horizontalInset - constants.horizontalInset - constants.selectedImageViewSize - constants.horizontalInset
        let titleLabelHeight = HelperManager.textHeight(title, width: labelContainerWidth, font: constants.titleFont)
        let subTitleLabelHeight = HelperManager.textHeight(subText, width: labelContainerWidth, font: selected ? constants.titleFont : constants.subTitleNormalFont)
        let descriptionLabelHeight = HelperManager.textHeight(description, width: labelContainerWidth, font: selected ? constants.titleFont : constants.descriptionNormalFont)
        var height = constants.verticalInset + titleLabelHeight + constants.spaceBetweenLabels + subTitleLabelHeight + descriptionLabelHeight + constants.verticalInset
        if descriptionLabelHeight == 0 {
            height += constants.spaceBetweenLabels
        }
        return height
    }
}

extension SearchAddressItemCell {

    private func setupUI() {
        setupTitleLabel()
        setupSubTitleLabel()
        setupDescriptionLabel()
        setupAddressImageView()
        setupSelectedImageView()
        setupLoadingIndicator()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = constants.titleNormalColor
        titleLabel.font = constants.titleFont
        titleLabel.textAlignment = .left
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.numberOfLines = 0
    }

    private func setupSubTitleLabel() {
        addSubview(subTitle)
        subTitle.textColor = constants.subTitleNormalColor
        subTitle.font = constants.subTitleNormalFont
        subTitle.textAlignment = .left
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.8
        subTitle.numberOfLines = 0
    }

    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.textColor = constants.descriptionNormalColor
        descriptionLabel.font = constants.descriptionNormalFont
        descriptionLabel.textAlignment = .left
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.8
        descriptionLabel.numberOfLines = 0
    }

    private func setupAddressImageView() {
        addSubview(addressImageView)
        addressImageView.image = theme.imageAssets.mapPinImage
        addressImageView.contentMode = .scaleAspectFit
        addressImageView.setImageColor(color: constants.descriptionNormalColor)
    }

    private func setupSelectedImageView() {
        addSubview(selectedImageView)
        selectedImageView.image = theme.imageAssets.redCheckMark
        selectedImageView.isHidden = true
        selectedImageView.contentMode = .scaleAspectFit
    }

    private func setupLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.isHidden = true
    }

    private func setupConstraints() {
        addressImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(constants.horizontalInset)
            make.size.equalTo(constants.addressImageViewSize)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(constants.verticalInset)
            make.leading.equalTo(addressImageView.snp.trailing).offset(constants.horizontalInset)
            make.trailing.equalTo(selectedImageView.snp.leading).offset(-constants.horizontalInset)
        }

        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(constants.spaceBetweenLabels)
            make.leading.trailing.equalTo(titleLabel)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subTitle.snp.bottom).offset(constants.spaceBetweenLabels)
            make.leading.trailing.equalTo(subTitle)
        }

        selectedImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(constants.selectedImageViewSize)
            make.trailing.equalToSuperview().offset(-constants.horizontalInset)
        }

        loadingIndicator.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(constants.loadingIndicatorSize)
            make.centerX.equalTo(selectedImageView)
        }
    }
}
