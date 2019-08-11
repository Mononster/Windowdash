//
//  SearchAddressInputCell.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

final class SearchAddressInputCell: UICollectionViewCell {

    struct Constants {
        let horizontalInset: CGFloat = 16
        let containerHeight: CGFloat = 64
        let height: CGFloat = 64
    }

    private let container: UIView
    private let searchImageView: UIImageView
    private let searchLabel: UILabel
    let searchTextField: DoordashTextField

    private let constants = Constants()
    private let theme = ApplicationDependency.manager.theme

    override public init(frame: CGRect) {
        container = UIView()
        searchImageView = UIImageView()
        searchLabel = UILabel()
        searchTextField = DoordashTextField()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupView(title: String,
                          searchDelegate: UITextFieldDelegate? = nil,
                          hideSearchField: Bool = true) {
        searchLabel.text = title
        searchTextField.delegate = searchDelegate
        searchTextField.isHidden = hideSearchField
        searchLabel.isHidden = !hideSearchField
        searchImageView.isHidden = !hideSearchField
    }
}

extension SearchAddressInputCell {

    private func setupUI() {
        setupContainer()
        setupTextField()
        setupSearchImageView()
        setupConstraints()
    }

    private func setupContainer() {
        addSubview(container)
        container.backgroundColor = theme.colors.white
    }

    private func setupTextField() {
        container.addSubview(searchTextField)
        searchTextField.backgroundColor = theme.colors.white
        searchTextField.font = theme.fonts.medium16
        searchTextField.textColor = theme.colors.darkGray
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.layer.cornerRadius = 16
        searchTextField.placeholder = "Search for a new address"
    }

    private func setupSearchImageView() {
        container.addSubview(searchImageView)
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.image = theme.imageAssets.searchIcon
        searchImageView.setImageColor(color: theme.colors.darkGray)
    }

    private func setupConstraints() {
        container.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(constants.containerHeight)
        }

        searchImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(constants.horizontalInset)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }

        searchTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(searchImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-constants.horizontalInset)
            make.top.bottom.equalToSuperview()
        }
    }
}
