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

    @IBOutlet weak var defaultImageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    static let height: CGFloat = 250
    static let identifier: String = "SkeletonLoadingTitleTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
