//
//  SortOptionSelectionView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/4/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import IGListKit
import SnapKit
import UIKit

final class SortOptionSelectionView: FullScreenPresentableView {

    struct Constants {
        let horizontalSpace: CGFloat = 32
        let titleLabelHeight: CGFloat = 32
        let verticalSpace: CGFloat = 12
        let cancelButtonSize: CGFloat = 16
        let actionButtonHeight: CGFloat = 50
        let dismissVelocityThreshold: CGFloat = 1000
    }

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: nil)
    }()

    private let container: UIView
    private let collectionView: UICollectionView
    private let titleLabel: UILabel
    private let cancelButton: UIButton
    private let actionButton: UIButton

    private var currentContainerHeight: CGFloat = 0
    private let constants = Constants()
    private let collectionSectionController: CollectionFilterSectionController
    private let rangeSectionController: RatingFilterSectionController
    private var sectionData: [ListDiffable] = []
    private var currentViewModel: SortOptionSelectionViewModel?

    var viewState: ViewPresentingState = .hidden

    override init(frame: CGRect) {
        container = UIView()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        titleLabel = UILabel()
        cancelButton = UIButton()
        actionButton = UIButton()
        collectionSectionController = CollectionFilterSectionController()
        rangeSectionController = RatingFilterSectionController()
        super.init(frame: CGRect.zero)
        adapter.collectionView = self.collectionView
        adapter.dataSource = self
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-self.bottomSafePadding)
        }
    }

    override func animateForOpening() {
        super.animateForOpening()
        container.alpha = 1
        viewState = .presenting
        container.snp.updateConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(-currentContainerHeight)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.viewState = .present
        })
    }

    override func hide(duration: TimeInterval = 0.25, completion: (() -> Void)?) {
        super.hide(duration: duration, completion: completion)
        viewState = .dismissing
        container.snp.updateConstraints { make in
            make.top.equalTo(self.snp.bottom)
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.viewState = .hidden
        })
    }

    func configData(viewModel: SortOptionSelectionViewModel) {
        sectionData.removeAll()
        currentViewModel = viewModel
        titleLabel.text = viewModel.model.displayValue.uppercased()
        switch viewModel.model.kind {
        case .binary, .sort: break
        case .collection:
            sectionData.append(CollectionFilterPresentingModel(items:
                viewModel.model.selections.map { CollectionFilterItemPresentingModel(
                    displayValue: $0, isSelected: viewModel.model.selectedValues.contains($0
                ))}
            ))
        case .range:
            sectionData.append(RatingFilterPresentingModel(
                displayValues: viewModel.model.selections,
                selectedValue: viewModel.model.selectedValues.first ?? viewModel.model.selections.first ?? ""
            ))
            break
        }
        adapter.performUpdates(animated: true)
    }

    private func getCommonUIHeight() -> CGFloat {
        return constants.verticalSpace + constants.titleLabelHeight + constants.verticalSpace + constants.verticalSpace + constants.actionButtonHeight
    }

    override func setupUI() {
        super.setupUI()
        setupContainer()
        setupTitleLabel()
        setupCancelButton()
        setupCollectionView()
        setupActionButton()
        setupConstraints()
    }
}

extension SortOptionSelectionView {

    private func setupContainer() {
        addSubview(container)
        container.backgroundColor = theme.colors.white
        container.layer.cornerRadius = 6
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        container.addGestureRecognizer(panGesture)
    }

    private func setupTitleLabel() {
        container.addSubview(titleLabel)
        titleLabel.textColor = theme.colors.black
        titleLabel.font = theme.fonts.bold16
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
    }

    private func setupCancelButton() {
        container.addSubview(cancelButton)
        cancelButton.setImage(theme.imageAssets.dismissIcon, for: .normal)
        cancelButton.contentHorizontalAlignment = .center
        cancelButton.contentVerticalAlignment = .center
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }

    private func setupCollectionView() {
        container.addSubview(collectionView)
        collectionView.backgroundColor = theme.colors.white
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupActionButton() {
        container.addSubview(actionButton)
        actionButton.backgroundColor = theme.colors.doorDashRed
        actionButton.setTitle("View Results", for: .normal)
        actionButton.titleLabel?.textColor = theme.colors.white
        actionButton.contentVerticalAlignment = .center
        actionButton.contentHorizontalAlignment = .center
        actionButton.titleLabel?.font = theme.fonts.bold18
        actionButton.layer.cornerRadius = 6
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        currentContainerHeight = getCommonUIHeight() + CollectionFilterContainerView.height
        container.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(currentContainerHeight)
            make.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(constants.verticalSpace)
            make.height.equalTo(constants.titleLabelHeight)
            make.leading.trailing.equalToSuperview().inset(constants.horizontalSpace)
        }

        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(-constants.horizontalSpace)
            make.size.equalTo(constants.cancelButtonSize)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(constants.verticalSpace)
            make.bottom.equalTo(actionButton.snp.top).offset(-constants.verticalSpace)
        }

        actionButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(constants.actionButtonHeight)
            make.bottom.equalToSuperview()
        }
    }
}

extension SortOptionSelectionView: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is CollectionFilterPresentingModel:
            return collectionSectionController
        case is RatingFilterPresentingModel:
            return rangeSectionController
        default:
            fatalError()
        }
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension SortOptionSelectionView {

    @objc
    private func cancelButtonTapped() {
        hide(completion: nil)
    }

    @objc
    private func actionButtonTapped() {
        if currentViewModel?.model.kind == .collection {
            currentViewModel?.applyFilter(selection: collectionSectionController.getSelectedData())
        }
        if currentViewModel?.model.kind == .range {
            currentViewModel?.applyFilter(selection: [rangeSectionController.getSelectedValue()])
        }
        hide(completion: nil)
    }

    @objc
    private func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self)
        let containerTranslation = panGesture.translation(in: container)
        let backgroundBeginAlpha: CGFloat = 0.5
        switch panGesture.state {
        case .changed:
            if translation.y > 0 {
                backgroundView.alpha = min(backgroundBeginAlpha, (1 - containerTranslation.y / currentContainerHeight) * backgroundBeginAlpha)
                container.alpha = min(1, (1 - containerTranslation.y / currentContainerHeight))
            }
            container.transform = .init(translationX: 0, y: max(0, translation.y))
        case .ended:
            let velocity = panGesture.velocity(in: self).y
            if velocity > constants.dismissVelocityThreshold || containerTranslation.y > currentContainerHeight / 2 {
                hide(completion: {
                    self.container.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                    self.container.transform = .identity
                    self.container.alpha = 1
                    self.backgroundView.alpha = backgroundBeginAlpha
                })
            }
        default: break
        }
    }
}
