//
//  SkeletonLoadingView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit
import SkeletonView

final class SkeletonLoadingView: UIView {

    let tableView: UITableView
    let imageView: UIImageView

    override init(frame: CGRect) {
        self.tableView = UITableView()
        self.imageView = UIImageView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        self.isHidden = false
        self.isSkeletonable = true
        tableView.isHidden = false
        tableView.isSkeletonable = true
        self.superview?.bringSubviewToFront(self)
        let gradient = SkeletonGradient(baseColor: UIColor.clouds.withAlphaComponent(0.5))
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        self.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }

    func hide() {
        self.hideSkeleton()
        self.isHidden = true
        //self.removeFromSuperview()
    }
}

extension SkeletonLoadingView {

    private func setupUI() {
        setupTableView()
        setupConstraints()
        self.backgroundColor = ApplicationDependency.manager.theme.colors.white
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.isSkeletonable = false
        imageView.image = UIImage(named: "avatar")
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = ApplicationDependency.manager.theme.colors.white
        tableView.register(SkeletonLoadingTitleTableViewCell.self, forCellReuseIdentifier: SkeletonLoadingTitleTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.isUserInteractionEnabled = false
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SkeletonLoadingView: SkeletonTableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonLoadingTitleTableViewCell.identifier, for: indexPath) as! SkeletonLoadingTitleTableViewCell
        cell.isSkeletonable = true
        return cell
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return SkeletonLoadingTitleTableViewCell.identifier
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SkeletonLoadingTitleTableViewCell.height
    }
}

extension SkeletonLoadingView: UITableViewDelegate {

}
