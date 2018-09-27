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

final class BrowseFoodViewModel {

    struct UIConfigure {
        static let homePageLeadingSpace: CGFloat = 18
        static let cuisineCategoriesOneScreenDisplayCount: CGFloat = 4
        static func getCuisineItemSize(collectionViewWidth: CGFloat) -> CGFloat {
            let displayCount = BrowseFoodViewModel.UIConfigure.cuisineCategoriesOneScreenDisplayCount
            let marginRight: CGFloat = 10
            let width = collectionViewWidth
            let itemWidth = (width - (displayCount - 1) * marginRight) / displayCount
            return itemWidth
        }
    }

    let user: User
    let service: BrowseFoodAPIService
    var allStores: [Store] = []
    var mainView: BrowseFoodMainView?
    var sectionData: [ListDiffable] = []
    var pageOffset: Int? = 0

    init(service: BrowseFoodAPIService) {
        self.service = service
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

    func generateSectionData(mainView: BrowseFoodMainView) {
        sectionData.removeAll()
        if mainView.cuisineCategories.count > 0 {
            generateDataForCuisine(cuisineCategories: mainView.cuisineCategories)
        }
        if mainView.storeSections.count > 0 {
            generateDataForStoreCarousel(storeSections: mainView.storeSections)
        }
        if allStores.count > 0 {
            generateDataForAllStores(stores: allStores)
        }
    }

    func generateDataForCuisine(cuisineCategories: [BrowseFoodCuisineCategory]) {
        var pages: [CuisinePage] = []
        var items: [CuisineItem] = []
        var count = 0
        for cuisine in cuisineCategories {
            guard let url = cuisine.coverImageURL else {
                continue
            }
            items.append(CuisineItem(imageURL: url, title: cuisine.friendlyName))
            count += 1
            if count == Int(BrowseFoodViewModel.UIConfigure.cuisineCategoriesOneScreenDisplayCount) {
                pages.append(CuisinePage(items: items))
                items.removeAll()
                count = 0
            }
        }
        sectionData.append(CuisinePages(pages: pages))
    }

    func generateDataForStoreCarousel(storeSections: [BrowseFoodSectionStore]) {
        let largeDisplayWidth = StoreCarouselLargeDisplayCell.width
        let twoStoreDisplayWidth = StoreCarouselTwoStoresCell.width
        let testSubTitle = "39 min Free delivery"
        for section in storeSections {
            if section.stores.count < 1 {
                continue
            }
            if section.stores.count == 1 || section.stores.count == 2 {
                let firstStore = section.stores[0]
                guard let url = URL(string: firstStore.headerImageURL ?? "") else {
                    continue
                }
                let titleHeight = HelperManager.textHeight(
                    firstStore.name,
                    width: largeDisplayWidth,
                    font: StoreCarouselLargeDisplayCell.titleFont
                )
                sectionData.append(StoreCarouselItems(
                    items: [StoreCarouselItem(
                        imageURL: url, title: firstStore.name, subTitle: testSubTitle
                        )],
                    carouselTitle: section.title,
                    maxTitleHeight: titleHeight,
                    largeDisplayTitleHeight: titleHeight,
                    carouselDescription: section.subTitle)
                )
                continue
            } else {
                var items: [StoreCarouselItem] = []
                var count = 0
                var maxTitleHeight: CGFloat = 0
                var largeDisplayTitleHeight: CGFloat = 0
                for store in section.stores {
                    if count == 3 {
                        break
                    }
                    guard let url = URL(string: store.headerImageURL ?? "") else {
                        continue
                    }
                    if count > 0 {
                        let titleHeight = HelperManager.textHeight(
                            store.name, width: twoStoreDisplayWidth,
                            font: StoreCarouselSingleStoreView.titleFont
                        )
                        maxTitleHeight = max(maxTitleHeight, titleHeight)
                    } else {
                        largeDisplayTitleHeight = HelperManager.textHeight(
                            store.name, width: largeDisplayWidth,
                            font: StoreCarouselLargeDisplayCell.titleFont
                        )
                    }
                    items.append(StoreCarouselItem(
                        imageURL: url, title: store.name, subTitle: testSubTitle
                    ))
                    count += 1
                }
                sectionData.append(StoreCarouselItems(
                    items: items,
                    carouselTitle: section.title.uppercased(),
                    maxTitleHeight: maxTitleHeight,
                    largeDisplayTitleHeight: largeDisplayTitleHeight,
                    carouselDescription: section.subTitle
                ))
            }
        }
    }

    func generateDataForAllStores(stores: [Store]) {
        var items: [BrowseFoodAllStoreItem] = []
        for store in stores {
            let urls = getMenuURLsFrom(store: store)
            let menuItems = urls.map { url in
                return BrowseFoodAllStoreMenuItem(imageURL: url)
            }
            items.append(BrowseFoodAllStoreItem(
                menuItems: menuItems,
                storeName: store.name,
                priceAndCuisine: "Bubble Tea, Coffee",
                rating: "4.6, 20000+ ratings",
                deliveryTime: "30 min",
                deliveryCost: "Free delivery")
            )
        }
//        if let item = sectionData.last as? BrowseFoodAllStoreItems {
//            item.items.append(contentsOf: items)
//        } else {
            sectionData.append(contentsOf: items)
//        }
    }

    func getMenuURLsFrom(store: Store) -> [URL] {
        guard let menus = store.menus, menus.count > 0 else {
            return []
        }
        var urls: [URL] = []
        for menu in menus {
            if let items = menu.items {
                for item in items {
                    if let urlString = item.url, let url = URL(string: urlString) {
                        urls.append(url)
                    }
                }
            }
        }
        return urls
    }

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
        fetchAllStores { (errorMsg) in
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

    func fetchAllStores(completion: @escaping (String?) -> ()) {
        guard let lat = user.defaultAddress?.latitude, let lng = user.defaultAddress?.longitude else {
            fatalError("User MUST have an address at this point")
        }
        guard let pageOffset = pageOffset else {
            completion("No more data")
            return
        }
        let request = FetchAllStoresRequestModel(
            limit: 50, offset: pageOffset, latitude: lat, longitude: lng, sortOption: .asap
        )
        service.fetchAllStores(request: request) { (response, error) in
            if let error = error as? BrowseFoodAPIServiceError {
                completion(error.errorMessage)
                return
            }
            if let response = response {
                self.pageOffset = response.nextOffset
                self.allStores.append(contentsOf: response.stores)
            }
            completion(nil)
        }
    }
}

