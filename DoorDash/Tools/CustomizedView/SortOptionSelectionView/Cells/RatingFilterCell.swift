//
//  RatingFilterCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/6/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class RatingFilterCell: UICollectionViewCell {

    struct Constants {
        let height: CGFloat = 220
        let sliderHeight: CGFloat = 80
        let verticalSpace: CGFloat = 12
        let horizontalSpace: CGFloat = 32
        let spaceBetweenImageAndLabel: CGFloat = 8
        let spaceBetweenLabelAndDescription: CGFloat = 0
        let spaceBetweenDescriptionAndSlider: CGFloat = 38
        let ratingStarSize: CGFloat = 20
        let ratingLabelFont: UIFont = ApplicationDependency.manager.theme.fonts.bold32
    }

    private let sliderView: RatingSliderView
    private let ratingContainer: UIView
    private let ratingLabel: UILabel
    private let ratingStar: UIImageView
    private let descriptionLabel: UILabel
    private let constants = Constants()

    var didUpdatedValue: ((String) -> Void)?

    override init(frame: CGRect) {
        sliderView = RatingSliderView()
        ratingContainer = UIView()
        ratingLabel = UILabel()
        ratingStar = UIImageView()
        descriptionLabel = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(values: [String], defaultValue: String) {
        layoutIfNeeded()
        sliderView.setupView(values: values, defaultValue: defaultValue)
        ratingLabel.text = defaultValue
        let textWidth = HelperManager.textWidth(defaultValue, font: constants.ratingLabelFont)
        let textHeight = HelperManager.textHeight(defaultValue, width: frame.width, font: constants.ratingLabelFont)
        ratingContainer.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(constants.verticalSpace)
            make.width.equalTo(textWidth + constants.spaceBetweenImageAndLabel + constants.ratingStarSize)
            make.height.equalTo(textHeight + 2 * 4)
            make.centerX.equalToSuperview()
        }
    }
}

extension RatingFilterCell {

    private func setupUI() {
        setupRatingContainer()
        setupRatingLabel()
        setupRatingStar()
        setupDescriptionLabel()
        setupSliderView()
        setupConstraints()
    }

    private func setupRatingContainer() {
        addSubview(ratingContainer)
        ratingContainer.backgroundColor = .clear
    }

    private func setupRatingLabel() {
        ratingContainer.addSubview(ratingLabel)
        ratingLabel.textColor = ApplicationDependency.manager.theme.colors.black
        ratingLabel.font = constants.ratingLabelFont
        ratingLabel.textAlignment = .left
        ratingLabel.adjustsFontSizeToFitWidth = true
        ratingLabel.minimumScaleFactor = 0.5
        ratingLabel.numberOfLines = 1
    }

    private func setupRatingStar() {
        ratingContainer.addSubview(ratingStar)
        ratingStar.image = ApplicationDependency.manager.theme.imageAssets.ratingStarFull
        ratingStar.setImageColor(color: ApplicationDependency.manager.theme.colors.black)
        ratingStar.contentMode = .scaleAspectFit
    }

    private func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.textColor = ApplicationDependency.manager.theme.colors.gray
        descriptionLabel.font = ApplicationDependency.manager.theme.fonts.medium18
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        descriptionLabel.numberOfLines = 1
        descriptionLabel.text = "and over"
    }

    private func setupSliderView() {
        addSubview(sliderView)
        sliderView.delegate = self
    }

    private func setupConstraints() {
        ratingLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        ratingStar.snp.makeConstraints { (make) in
            make.leading.equalTo(ratingLabel.snp.trailing).offset(
                constants.spaceBetweenImageAndLabel
            )
            make.centerY.equalTo(ratingLabel)
            make.size.equalTo(constants.ratingStarSize)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ratingContainer.snp.bottom).offset(
                constants.spaceBetweenLabelAndDescription
            )
            make.centerX.equalToSuperview()
        }

        sliderView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(constants.sliderHeight)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(
                constants.spaceBetweenDescriptionAndSlider
            )
        }
    }
}

extension RatingFilterCell: RatingSliderViewDelegate {

    func didUpdateToValue(_ value: String) {
        ratingLabel.text = value
        let textWidth = HelperManager.textWidth(value, font: constants.ratingLabelFont)
        ratingContainer.snp.updateConstraints { (make) in
            make.width.equalTo(textWidth + constants.spaceBetweenImageAndLabel + constants.ratingStarSize)
        }
        didUpdatedValue?(value)
    }
}
