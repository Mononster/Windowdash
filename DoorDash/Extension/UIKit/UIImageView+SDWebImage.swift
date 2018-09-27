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

