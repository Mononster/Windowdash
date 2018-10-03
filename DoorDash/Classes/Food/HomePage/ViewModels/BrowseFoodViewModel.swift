//
//  BrowseFoodViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-23.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

enum BrowseFoodSortOptionType: String {
    case asap = "asap"
}

final class BrowseFoodViewModel: PresentableViewModel {

    struct UIConfigure {
        static let homePageLeadingSpace: CGFloat = 18
        static let menuCollectionViewSpacing: CGFloat = 6
        static let cuisineCategoriesOneScreenDisplayCount: CGFloat = 4
        static func getCuisineItemSize(collectionViewWidth: CGFloat) -> CGFloat {
            let displayCount = cuisineCategoriesOneScreenDisplayCount
            let width = collectionViewWidth
            let itemWidth = (width - (displayCount - 1) * 10) / displayCount
            return itemWidth
        }
    }

    private let user: User
    private let service: BrowseFoodAPIService
    private let storeList: StoreListViewModel
    private var mainView: BrowseFoodMainView?

    var sectionData: [ListDiffable] = []

    init(service: BrowseFoodAPIService) {
        self.service = service
        self.storeList = StoreListViewModel(service: service)
        guard let user = ApplicationEnvironment.current.currentUser else {
            fatalError()
        }
        self.user = user
    }

    func generateUserAddressContent() -> String {
        return user.defaultAddress?.shortName ?? ""
    }
}

extension BrowseFoodViewModel {

    func fetchMainViewLayout(completion: @escaping (String?) -> ()) {
        guard let lat = user.defaultAddress?.latitude, let lng = user.defaultAddress?.longitude else {
            fatalError("User MUST have an address at this point")
        }
        let tasks = DispatchGroup()
        tasks.enter()
        var taskSucceeds = true
        service.fetchPageLayout(userLat: lat, userLng: lng) { (mainView, error) in
            if let error = error as? APIServiceError {
                log.error(error)
                taskSucceeds = false
            }
            self.mainView = mainView
            tasks.leave()
        }
        tasks.enter()
        storeList.fetchStores { (errorMsg) in
            if let error = errorMsg {
                log.error(error)
                taskSucceeds = false
            }
            tasks.leave()
        }
        tasks.notify(queue: .main) {
            if taskSucceeds, let mainView = self.mainView {
                self.generateSectionData(mainView: mainView)
                completion(nil)
            } else {
                completion("Something went wrong.")
            }
        }
    }

    func loadMoreStores(completion: @escaping (Bool) -> ()) {
        self.storeList.loadMoreStores { (stores, shouldRefresh) in
            if !shouldRefresh {
                completion(false)
                return
            }
            self.sectionData.append(contentsOf: stores)
            completion(true)
        }
    }
}

extension BrowseFoodViewModel {

    private func generateSectionData(mainView: BrowseFoodMainView) {
        sectionData.removeAll()
        if mainView.cuisineCategories.count > 0 {
            generateDataForCuisine(cuisineCategories: mainView.cuisineCategories)
        }
        if mainView.storeSections.count > 0 {
            generateDataForStoreCarousel(storeSections: mainView.storeSections)
        }
        if storeList.allStores.count > 0 {
            sectionData.append(BrowseFoodAllStoreHeaderModel(title: "ALL RESTAURANTS"))
            generateDataForAllStores(stores: storeList.allStores)
        }
    }

    private func generateDataForAllStores(stores: [StoreViewModel]) {
        self.storeList.generatePresentingStores { (stores) in
            let items = self.storeList.generateDataForAllStores(stores: stores, addTopInset: false)
            self.sectionData.append(contentsOf: items)
        }
    }
}

extension BrowseFoodViewModel {

    private func generateDataForCuisine(cuisineCategories: [BrowseFoodCuisineCategory]) {
        var pages: [CuisinePage] = []
        var items: [CuisineItem] = []
        var count = 0
        for cuisine in cuisineCategories {
            guard let url = cuisine.coverImageURL else {
                continue
            }
            items.append(CuisineItem(imageURL: url,
                                     title: cuisine.friendlyName,
                                     cuisine: cuisine))
            count += 1
            if count == Int(BrowseFoodViewModel.UIConfigure.cuisineCategoriesOneScreenDisplayCount) {
                pages.append(CuisinePage(items: items))
                items.removeAll()
                count = 0
            }
        }
        if items.count > 0 {
            pages.append(CuisinePage(items: items))
        }
        sectionData.append(CuisinePages(pages: pages))
    }

    private func generateDataForStoreCarousel(storeSections: [BrowseFoodSectionStore]) {
        for section in storeSections {
            if section.stores.count < 1 {
                continue
            }
            if section.stores.count == 1 || section.stores.count == 2 {
                generateDataForStoreCarouselLargeDisplay(section: section)
                continue
            } else {
                generateDataForStoreCarouselTwoStores(section: section)
            }
        }
    }

    private func generateDataForStoreCarouselLargeDisplay(section: BrowseFoodSectionStore) {
        let firstStore = section.stores[0]
        guard let url = firstStore.headerImageURL else {
            return
        }
        let largeDisplayWidth = StoreCarouselLargeDisplayCell.width
        let titleHeight = HelperManager.textHeight(
            firstStore.nameDisplay,
            width: largeDisplayWidth,
            font: StoreCarouselLargeDisplayCell.titleFont
        )
        sectionData.append(StoreCarouselItems(
            id: section.id,
            items: [StoreCarouselItem(
                imageURL: url,
                title: firstStore.nameDisplay,
                subTitle: firstStore.getDeliveryTimeAndCostCombineString()
            )],
            carouselTitle: section.title,
            maxTitleHeight: titleHeight,
            largeDisplayTitleHeight: titleHeight,
            carouselDescription: section.subTitle)
        )
    }

     private func generateDataForStoreCarouselTwoStores(section: BrowseFoodSectionStore) {
        let twoStoreDisplayWidth = StoreCarouselTwoStoresCell.width
        let largeDisplayWidth = StoreCarouselLargeDisplayCell.width
        var items: [StoreCarouselItem] = []
        var count = 0
        var maxTitleHeight: CGFloat = 0
        var largeDisplayTitleHeight: CGFloat = 0
        for store in section.stores {
            if count == 3 {
                break
            }
            guard let url = store.headerImageURL else {
                continue
            }
            if count > 0 {
                let titleHeight = HelperManager.textHeight(
                    store.nameDisplay, width: twoStoreDisplayWidth,
                    font: StoreCarouselSingleStoreView.titleFont
                )
                maxTitleHeight = max(maxTitleHeight, titleHeight)
            } else {
                largeDisplayTitleHeight = HelperManager.textHeight(
                    store.nameDisplay, width: largeDisplayWidth,
                    font: StoreCarouselLargeDisplayCell.titleFont
                )
            }
            items.append(StoreCarouselItem(
                imageURL: url, title: store.nameDisplay,
                subTitle: store.getDeliveryTimeAndCostCombineString()
            ))
            count += 1
        }
        sectionData.append(StoreCarouselItems(
            id: section.id,
            items: items,
            carouselTitle: section.title,
            maxTitleHeight: maxTitleHeight,
            largeDisplayTitleHeight: largeDisplayTitleHeight,
            carouselDescription: section.subTitle
        ))
    }
}
