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

        static func getAnimatedCuisineItemSize(collectionViewWidth: CGFloat) -> CGFloat {
            let displayCount = cuisineCategoriesOneScreenDisplayCount + 0.8
            let width = collectionViewWidth
            let itemWidth = width / displayCount
            return itemWidth
        }
    }

    private let user: User
    private let service: BrowseFoodAPIService
    private let storeList: StoreListViewModel
    private var mainView: BrowseFoodMainView?
    private var searchFilters: ConsumerSearchFilter?

    var sectionDataCache: [ListDiffable] = []
    var sectionData: [ListDiffable] = []
    var showedSkeleton: Bool = false
    var currentFilter: [String: [String: Any]] = [:]

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

    func getCurrentNumStoreDisplay() -> String {
        return self.storeList.numStores == 0 ? "NO STORES" : "\(self.storeList.numStores) STORES"
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
        service.fetchFilterOptions(userLat: lat, userLng: lng) { (filter, error) in
            if let error = error as? APIServiceError {
                log.error(error)
                taskSucceeds = false
            }
            self.searchFilters = filter
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
                self.generateSectionData(mainView: mainView, filter: self.searchFilters)
                completion(nil)
            } else {
                completion("Something went wrong.")
            }
        }
    }

    func loadMoreStores(completion: @escaping (Bool) -> ()) {
        storeList.loadMoreStores { (stores, shouldRefresh) in
            if !shouldRefresh {
                completion(false)
                return
            }
            self.sectionData.append(contentsOf: stores)
            completion(true)
        }
    }

    func loadStores(completion: @escaping (String?) -> ()) {
        if currentFilter.isEmpty {
            fetchAllStoreWithoutFilter(completion: completion)
        } else {
            fetchStoresWithFilter(completion: completion)
        }
    }

    private func fetchAllStoreWithoutFilter(completion: @escaping (String?) -> ()) {
        storeList.setFilterOptions(models: [])
        sectionData = sectionDataCache
        storeList.fetchStores { (error) in
            if let error = error {
                log.error(error)
                completion(error)
                return
            }
            if self.storeList.allStores.count > 0 {
                self.sectionData.removeLast()
                self.generateDataForAllStores(stores: self.storeList.allStores)
            }
            completion(nil)
        }
    }

    private func fetchStoresWithFilter(completion: @escaping (String?) -> ()) {
        storeList.setFilterOptions(models: currentFilter.values.map { StoreFilterRequestModel(values: $0) })
        sectionData.removeAll()
        if let cusineCache = sectionDataCache.first {
            sectionData.append(cusineCache)
        }
        if let filterCache = sectionDataCache[safe: 1] {
            sectionData.append(filterCache)
        }
        storeList.fetchFirstList(addTopInset: false) { items, errorMsg in
            if let error = errorMsg {
                completion(error)
                return
            }
            self.sectionData.append(BrowseFoodAllStoreHeaderModel(
                title: "\(self.storeList.numStores) STORES NEAR YOU", showSeparator: false)
            )
            self.sectionData.append(contentsOf: items)
            completion(nil)
        }
    }
}

extension BrowseFoodViewModel {

    private func generateSectionData(mainView: BrowseFoodMainView, filter: ConsumerSearchFilter?) {
        sectionData.removeAll()
        if mainView.cuisineCategories.count > 0 {
            generateDataForAnimatedCuisine(cuisineCategories: mainView.cuisineCategories)
        }
        if let filter = filter, !filter.filters.isEmpty {
            generateDataForFilters(searchFilter: filter)
        }
        if mainView.storeSections.count > 0 {
            generateDataForStoreHorizontalCarousel(storeSections: mainView.storeSections)
            //generateDataForStoreCarousel(storeSections: mainView.storeSections)
        }
        if storeList.allStores.count > 0 {
            sectionData.append(BrowseFoodAllStoreHeaderModel(title: "ALL RESTAURANTS", showSeparator: true))
            generateDataForAllStores(stores: storeList.allStores)
        }
        sectionDataCache = sectionData
    }

    private func generateDataForAllStores(stores: [StoreViewModel]) {
        storeList.generatePresentingStores { (stores) in
            let items = self.storeList.generateDataForAllStores(stores: stores, addTopInset: false)
            self.sectionData.append(contentsOf: items)
        }
    }
}

extension BrowseFoodViewModel {

    private func generateDataForStaticCuisine(cuisineCategories: [BrowseFoodCuisineCategory]) {
        var pages: [CuisinePage] = []
        var items: [CuisineItem] = []
        var count = 0
        for cuisine in cuisineCategories {
            guard let url = cuisine.animatedCoverImageURL else {
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

    private func generateDataForAnimatedCuisine(cuisineCategories: [BrowseFoodCuisineCategory]) {
        var items: [CuisineItem] = []
        for cuisine in cuisineCategories {
            guard let url = cuisine.animatedCoverImageURL else {
                continue
            }
            items.append(CuisineItem(imageURL: url,
                                     title: cuisine.friendlyName,
                                     cuisine: cuisine))
        }
        sectionData.append(CuisinePage(items: items))
    }

    private func generateDataForFilters(searchFilter: ConsumerSearchFilter) {
        var items: [StoreSortItemPresentingModel] = []
        for filter in searchFilter.filters {
            var displayName = filter.displayName
            if filter.filterType == .range || filter.filterType == .collection {
                displayName = filter.defaultValues.joined(separator: ",")
            }
            items.append(StoreSortItemPresentingModel(
                id: filter.id,
                kind: filter.filterType,
                title: displayName,
                selected: false,
                displayValue: filter.displayName,
                selections: filter.allowedValues,
                selectedValues: filter.defaultValues)
            )
        }
        sectionData.append(StoreSortHorizontalPresentingModel(items: items))
    }

    private func generateDataForStoreHorizontalCarousel(storeSections: [BrowseFoodSectionStore]) {
        for (i, section) in storeSections.enumerated() {
            sectionData.append(StoreHorizontalCarouselItems(
                id: section.id,
                items: section.stores.map {
                    StoreHorizontalCarouselItem(
                        id: String($0.model.id),
                        imageURL: $0.headerImageURL,
                        title: $0.nameDisplay,
                        subTitle: $0.getDeliveryTimeAndCostCombineString()
                    )
                },
                carouselTitle: section.title,
                carouselDescription: nil,
                lastSection: i == storeSections.count - 1)
            )
        }
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
                id: String(firstStore.model.id),
                imageURL: url,
                title: firstStore.nameDisplay,
                subTitle: firstStore.getDeliveryTimeAndCostCombineString()
            )],
            carouselTitle: section.title,
            maxTitleHeight: titleHeight,
            largeDisplayTitleHeight: titleHeight,
            carouselDescription: nil)
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
                id: String(store.model.id),
                imageURL: url,
                title: store.nameDisplay,
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
            carouselDescription: nil
        ))
    }
}

extension BrowseFoodViewModel {

    func updateFilter(item: StoreSortItemPresentingModel) {
        var data: [String: Any] = [:]
        data["filter_id"] = item.id
        data["filter_type"] = item.kind.rawValue
        switch item.kind {
        case .range:
            guard let val = item.selectedValues.first else {
                break
            }
            data["lower_bound"] = val
        case .collection:
            data["values"] = item.selectedValues
        default: break
        }
        currentFilter[item.id] = data
        if !item.selected {
            currentFilter.removeValue(forKey: item.id)
        }
    }

    func updateCuisineFilter(name: String, selected: Bool) {
        guard selected else {
            currentFilter.removeValue(forKey: "cuisine")
            return
        }
        var data: [String: Any] = [:]
        data["filter_id"] = "cuisine"
        data["filter_type"] = "collection"
        data["values"] = [name]
        currentFilter["cuisine"] = data
    }
}
