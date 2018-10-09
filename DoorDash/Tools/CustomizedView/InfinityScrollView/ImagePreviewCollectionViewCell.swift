//
//  ImagePreviewCollectionViewCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage

class ImageBaseCell: UICollectionViewCell {

    let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageBaseCell {

    private func setupUI() {
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        imageView.sd_imageTransition = transition
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ImageBaseCell {

    func setImage(lowQualityURL: URL?, highQualityUrl: URL?) {
        let placeHolder = ApplicationDependency.manager.theme.imageAssets.grayRectBackground
        if let image = imageFor(url: highQualityUrl) {
            imageView.image = image
            return
        }
        if highQualityUrl != nil {
            loadImage(withPlaceholder: placeHolder, url: highQualityUrl, completion: nil)
        } else {
            loadImage(withPlaceholder: placeHolder, url: lowQualityURL, completion: nil)
        }
    }

    private func loadImage(withPlaceholder placeholder: UIImage?, url: URL?, completion: (() -> Void)?) {
        imageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            DispatchQueue.main.async {
                if let completion = completion {
                    completion()
                }
            }
        }
    }

    private func imageFor(url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        return SDImageCache.shared().imageFromCache(forKey: url.absoluteString)
    }
}


final class ImagePreviewCollectionViewCell: ImageBaseCell {

    let imageParallaxFactor: CGFloat = 100
    var imageTopInitialConstraint: CGFloat = 0
    var imageBottomInitialConstraint: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        imageView.snp.remakeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        self.imageTopInitialConstraint = 0
        self.imageBottomInitialConstraint = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setBackgroundOffset(_ offset: CGFloat) {

        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        imageView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(pixelOffset)
            make.bottom.equalToSuperview().offset(pixelOffset)
        }
    }
}
