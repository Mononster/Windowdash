//
//  AnimatedCuisineItemCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-11-02.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

final class AnimatedCuisineItemCell: UICollectionViewCell {

    private let title: UILabel
    private var animatedImageView: AnimationView?

    override init(frame: CGRect) {
        title = UILabel()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(imageURL: URL, title: String, selected: Bool) {
        self.title.text = title
        animatedImageView?.removeFromSuperview()
        animatedImageView = AnimationView(url: imageURL, closure: { (error) in
            
        })
        addSubview(animatedImageView!)
        animatedImageView?.contentMode = .scaleToFill
        animatedImageView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(animatedImageView!.snp.width).offset(12)
        }
        self.title.snp.makeConstraints { (make) in
            make.top.equalTo(animatedImageView!.snp.bottom).offset(-2)
            make.leading.trailing.equalToSuperview()
        }
        self.layoutIfNeeded()
        if selected {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            animatedImageView?.animationSpeed = 2
            animatedImageView?.play()
            self.title.textColor = ApplicationDependency.manager.theme.colors.doordashDarkCyan
        } else {
            animatedImageView?.currentProgress = 0
            self.title.textColor = ApplicationDependency.manager.theme.colors.black
        }
    }
}

extension AnimatedCuisineItemCell {

    private func setupUI() {
        setupLabels()
    }

    private func setupLabels() {
        addSubview(title)
        title.textColor = ApplicationDependency.manager.theme.colors.black
        title.font = ApplicationDependency.manager.theme.fonts.medium14
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.numberOfLines = 1
    }
}


