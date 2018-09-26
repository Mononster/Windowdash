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
            var pages: [CuisinePage] = []
            var items: [CuisineItem] = []
            var count = 0
            for cuisine in mainView.cuisineCategories {
                guard let url = cuisine.coverImageURL else {
                    continue
                }
                items.append(CuisineItem(imageURL: url, title: cuisine.friendlyName))
                count += 1
                if count ==
                    Int(BrowseFoodViewModel.UIConfigure.cuisineCategoriesOneScreenDisplayCount) {
                    pages.append(CuisinePage(items: items))
                    count = 0
                    items.removeAll()
                }
            }
            sectionData.append(CuisinePages(pages: pages))
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
