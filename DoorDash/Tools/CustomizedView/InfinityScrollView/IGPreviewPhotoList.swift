//
//  IGPreviewPhotoList.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

final class IGPreviewPhotoList: NSObject, ListDiffable {
    let photos: [PreviewPhoto]

    init(photos: [PreviewPhoto]) {
        self.photos = photos
    }

    subscript(index: Int) -> PreviewPhoto {
        get {
            return photos[index]
        }
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class PreviewPhoto: NSObject, ListDiffable {

    var lowQualityURL: URL?
    var highQualityURL: URL?

    var thumbImage: UIImage?
    var imageViewHolder: UIImageView?

    init(lowQualityURL: URL?, highQualityURL: URL?) {
        self.lowQualityURL = lowQualityURL
        self.highQualityURL = highQualityURL
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

