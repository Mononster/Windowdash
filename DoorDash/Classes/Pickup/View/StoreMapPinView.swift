//
//  StoreMapPinView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import MapKit

final class StoreMapPinView: MKAnnotationView {

    struct Constants {
        let imageSize: CGFloat = 50
        let selectedImageSize: CGFloat = 80
        let marginBetweenTitleAndImage: CGFloat = 2
    }

    private let imageView: UIImageView
    private let titleLabel: UILabel

    private let constants = Constants()
    private let theme = ApplicationDependency.manager.theme

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        titleLabel = UILabel()
        imageView = UIImageView()
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        imageView.image = selected ? theme.imageAssets.storePinSelected : theme.imageAssets.storePinNormal
        imageView.snp.updateConstraints { (make) in
            make.size.equalTo(selected ? constants.selectedImageSize : constants.imageSize)
        }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 20, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        })
    }

    func setupView(title: String) {
        titleLabel.text = title
    }
}

extension StoreMapPinView {

    private func setupUI() {
        setupTitleLabel()
        setupImageViews()
        setupConstraints()
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = theme.colors.black
        titleLabel.font = theme.fonts.bold10
        titleLabel.backgroundColor = theme.colors.white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        titleLabel.alpha = 0.8
    }

    private func setupImageViews() {
        addSubview(imageView)
        imageView.image = theme.imageAssets.storePinNormal
        imageView.contentMode = .scaleAspectFit
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(constants.imageSize)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(
                constants.marginBetweenTitleAndImage
            )
            make.centerX.equalTo(imageView)
        }
    }
}
