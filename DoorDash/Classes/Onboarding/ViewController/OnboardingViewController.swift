//
//  OnboardingViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

protocol OnboardingViewControllerDelegate: class {
    func showLoginSignupViewController(mode: SignupMode)
}

final class OnboardingViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    private let logoImageView: UIImageView
    private let signInButton: UIButton
    private let getStartedButton: UIButton
    private let collectionView: UICollectionView
    private let viewModel: OnboardingViewModel

    weak var delegate: OnboardingViewControllerDelegate?

    override init() {
        viewModel = OnboardingViewModel()
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        logoImageView = UIImageView()
        signInButton = UIButton()
        getStartedButton = UIButton()
        super.init()
        adapter.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension OnboardingViewController {

    private func setupUI() {
        setupLogoImageView()
        setupCollectionView()
        setupButtons()
        setupConstraints()
    }

    private func setupLogoImageView() {
        self.view.addSubview(logoImageView)
        logoImageView.image = theme.imageAssets.logoImage
        logoImageView.contentMode = .scaleAspectFit
    }

    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.backgroundColor = theme.colors.white
        collectionView.alwaysBounceVertical = false
    }

    private func setupButtons() {
        self.view.addSubview(signInButton)
        signInButton.layer.cornerRadius = 4
        signInButton.layer.borderColor = theme.colors.separatorGray.cgColor
        signInButton.layer.borderWidth = 0.5
        signInButton.backgroundColor = theme.colors.white
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(theme.colors.doorDashDarkGray, for: .normal)
        signInButton.titleLabel?.font = theme.fontSchema.semiBold17
        signInButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)

        self.view.addSubview(getStartedButton)
        getStartedButton.layer.cornerRadius = 4
        getStartedButton.backgroundColor = theme.colors.doorDashRed
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.setTitleColor(theme.colors.white, for: .normal)
        getStartedButton.titleLabel?.font = theme.fontSchema.semiBold17
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)

    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.current.statusBarHeight + 35)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(logoImageView.snp.width).dividedBy(5)
        }

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(getStartedButton.snp.top).offset(-16)
        }

        let buttonWidth = (self.view.frame.width - 20 * 2 - 12) / 2
        signInButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(46)
            make.width.equalTo(buttonWidth)
        }

        getStartedButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(signInButton.snp.trailing).offset(12)
            make.height.equalTo(signInButton)
            make.bottom.equalTo(signInButton)
        }
        
    }
}

extension OnboardingViewController {

    @objc
    func signinButtonTapped() {
        self.delegate?.showLoginSignupViewController(mode: .login)
    }

    @objc
    func getStartedButtonTapped() {
        self.delegate?.showLoginSignupViewController(mode: .register)
    }
}

extension OnboardingViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [OnboardingItems(items: viewModel.onboardingItems)]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HorizontalSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension OnboardingViewController: OnboardingCoordinatorDelegate {
    
    func didLoggedin(in coordinator: OnboardingCoordinator) {

    }
}

