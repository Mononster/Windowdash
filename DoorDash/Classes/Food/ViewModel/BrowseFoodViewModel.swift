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
        static let homePageLeadingSpace: CGFloat = 24
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
    var sectionData: [ListDiffable] = []

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
                sectionData.append(StoreCarouselItems(items: [
                    StoreCarouselItem(
                        imageURL: url, title: firstStore.name, subTitle: testSubTitle
                    )
                ], carouselTitle: section.title, maxTitleHeight: titleHeight))
                continue
            } else {
                var items: [StoreCarouselItem] = []
                var count = 0
                var maxTitleHeight: CGFloat = 0
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
                    }
                    items.append(StoreCarouselItem(
                        imageURL: url, title: store.name, subTitle: testSubTitle
                    ))
                    count += 1
                }
                sectionData.append(StoreCarouselItems(
                    items: items, carouselTitle: section.title, maxTitleHeight: maxTitleHeight
                ))
            }
        }
    }

    func fetchMainViewLayout(completion: @escaping (String?) -> ()) {
        guard let lat = user.defaultAddress?.latitude, let lng = user.defaultAddress?.longitude else {
            fatalError("User MUST have an address at this point")
        }
        service.fetchPageLayout(userLat: lat, userLng: lng) { (mainView, error) in
            if let error = error as? APIServiceError {
                completion(error.errorMessage)
                return
            }
            if let mainView = mainView {
                self.generateSectionData(mainView: mainView)
            }
            completion(nil)
        }
    }
}
