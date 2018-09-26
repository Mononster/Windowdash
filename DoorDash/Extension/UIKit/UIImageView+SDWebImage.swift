//
//  UIImageView+SDWebImage.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {

    func setImage(placeHolder: UIImage, regularURL: URL, highQualityURL: URL?) {
        if let image = imageFor(url: regularURL) {
            self.image = image
            return
        }
        let transition = SDWebImageTransition.fade
        transition.duration = 0.3
        self.sd_imageTransition = transition
        self.sd_setImage(with: regularURL, placeholderImage: placeHolder, completed: { (image, error, type, url) in
            if let highQualityURL = highQualityURL {
                self.sd_setImage(with: highQualityURL, placeholderImage: image)
            }
        })
    }

    private func imageFor(url: URL?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        return SDImageCache.shared().imageFromCache(forKey: url.absoluteString)
    }
}

