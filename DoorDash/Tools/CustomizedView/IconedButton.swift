//
//  IconedButton.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class IconedButton: UIButton {

    enum ButtonImageAlign {
        case left
        case right
        case top
    }

    enum ButtonComponentAlign {
        case center
        case left
    }

    typealias ImageSpacingGuide = UIEdgeInsets
    private var imageAlign: ButtonImageAlign = .left
    private var imageSpacingGuide: ImageSpacingGuide = UIEdgeInsets.zero
    private var componentAlign: ButtonComponentAlign?

    static func button(image: UIImage,
                       highlightedImage: UIImage? = nil,
                       imageAlign: ButtonImageAlign,
                       imageInset: UIEdgeInsets,
                       buttonComponentAlign: ButtonComponentAlign? = .left) -> IconedButton {
        let button = IconedButton()
        button.imageAlign = imageAlign
        button.setImage(image, for: .normal)
        if highlightedImage != nil {
            button.setImage(highlightedImage, for: .highlighted)
        }
        button.imageSpacingGuide = imageInset
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        button.componentAlign = buttonComponentAlign

        return button
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let imageFrame = imageView?.frame
        var imageCopy = imageFrame
        let titleFrame = titleLabel?.frame
        var titleCopy = titleFrame
        switch imageAlign {
        case .left:
            imageCopy?.origin.x = imageSpacingGuide.left
            titleCopy?.origin.x = max((availableSpace.width - (titleFrame?.width ?? 0))/2.0,
                                      (imageCopy?.maxX ?? 0) + imageSpacingGuide.right)

        case .right:
            imageCopy?.origin.x = availableSpace.maxX - imageSpacingGuide.right - (imageFrame?.width ?? 0)
            if titleCopy != nil {
                var unwrapped = titleCopy.unwrap()
                unwrapped.origin.x = min((availableSpace.width - unwrapped.width)/2.0,
                                         availableSpace.width - (imageFrame?.width ?? 0) - imageSpacingGuide.left - imageSpacingGuide.right)
                titleCopy = unwrapped
            }
        case .top:
            guard let imageSize = self.imageView?.image?.size
                else { return }
            self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + 6.0), right: 0.0)
            if titleCopy != nil {
                self.imageEdgeInsets = UIEdgeInsets(top: -((titleFrame?.height)! + 6.0), left: 0.0, bottom: 0.0, right: -(titleFrame?.width)!)
                let edgeOffset = abs((titleFrame?.height)! - imageSize.height) / 2.0
                self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
            }
        }
        if imageCopy != nil {
            imageView?.frame = imageCopy.unwrap()
        }
        if titleCopy != nil {
            let overflowTitleFrame = titleCopy.unwrap()
            let padding: CGFloat = componentAlign == .left
                ? 8.0 : imageSpacingGuide.left
            let minWidth = self.frame.width - padding - (imageView?.frame.maxX)! - ((titleLabel?.frame.minX)! - (imageView?.frame.maxX)!)
            let fittedTitleFrame = CGRect(x: overflowTitleFrame.minX,
                                          y: overflowTitleFrame.minY,
                                          width: min(overflowTitleFrame.width, minWidth),
                                          height: overflowTitleFrame.height)
            titleLabel?.frame = fittedTitleFrame
        }
    }
}


