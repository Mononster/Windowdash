//
//  InfinitieScrollView.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-04-13.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

protocol InfiniteScrollViewDelegate: class {
    func didSelect(cell: ImagePreviewCollectionViewCell?, at index: Int)
}

final class InfiniteScrollView: UIView {

    let collectionView: UICollectionView
    weak var delegate: InfiniteScrollViewDelegate?

    var imagesCount: Int {
        return infiniteScroll ? (itemsInSection / endlessScrollTimes) : itemsInSection
    }

    var itemsInSection:Int {
        return infiniteScroll ? ((photoList?.photos.count ?? 0) * endlessScrollTimes) : photoList?.photos.count ?? 0
    }

    var pageControlCurrentIndex: Int {
        let width = self.frame.width
        var currentIndex = Int((collectionView.contentOffset.x + width * 0.5) / width)
        currentIndex = max(0, currentIndex)
        return currentIndex % (photoList?.photos.count ?? 0)
    }

    private let pageControl: UIPageControl
    private var photoList: IGPreviewPhotoList?
    private var scrolledToFirst: Bool = false
    private let infiniteScroll: Bool = false
    private let endlessScrollTimes = 128

    private var firstItemIndex: Int {
        return infiniteScroll ? (itemsInSection / 2) : 0
    }

    override init(frame: CGRect) {
        pageControl = UIPageControl()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // only scroll to the firs cell once
        let flowLayout = InfiniteScrollCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        self.collectionView.contentInset = .zero
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)

        if !scrolledToFirst {
            let indexPath = IndexPath(item: firstItemIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
            scrolledToFirst = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getImage(with index: Int) -> UIImage? {
        guard let cell = getCell(with: index) else {
            return nil
        }
        return cell.imageView.image
    }

    func getCell(with index: Int) -> ImagePreviewCollectionViewCell? {
        guard let cell = collectionView.cellForItem(
            at: IndexPath(row: index, section: 0)
            ) as? ImagePreviewCollectionViewCell else {
                return nil
        }
        return cell
    }

    func scrollView(to Index: Int) {
        let indexPath = IndexPath(item: Index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
    }

    func setupCurrentImageCellOffset(cellOffsetFactor: CGFloat) {
        for cell in collectionView.visibleCells {
            if let cell = cell as? ImagePreviewCollectionViewCell {
                cell.setBackgroundOffset(cellOffsetFactor)
            }
        }
    }

    func setPhotos(photoList: IGPreviewPhotoList) {
        self.photoList = photoList
        self.collectionView.reloadData()
    }
}

extension InfiniteScrollView {

    private func setupUI() {
        setupCollectionView()
        setupPageControl()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(ImagePreviewCollectionViewCell.self,
                                forCellWithReuseIdentifier: "ImagePreviewCollectionViewCell")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func setupPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = photoList?.photos.count ?? 0
        pageControl.pageIndicatorTintColor = ApplicationDependency.manager.theme.colors.white
        pageControl.currentPageIndicatorTintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)

        pageControl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.bottom.equalToSuperview()
        }
    }
}

extension InfiniteScrollView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ImagePreviewCollectionViewCell.self, for: indexPath)
        let currentIndex = indexPath.row % imagesCount
        cell.setImage(lowQualityURL: photoList?[currentIndex].lowQualityURL,
                      highQualityUrl: photoList?[currentIndex].highQualityURL)
        return cell
    }
}

extension InfiniteScrollView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = pageControlCurrentIndex
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = getCell(with: indexPath.row)
        self.delegate?.didSelect(cell: cell, at: indexPath.row)
    }
}

extension InfiniteScrollView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
}
