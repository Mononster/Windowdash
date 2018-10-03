//
//  StoreDetailViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import UIKit

struct StoreDetailMenuSectionControlModel {
    let sectionStartPos: CGFloat
    let sectionEndPos: CGFloat
    let startCellIndex: Int
    let sectionIndex: Int
    let debugName: String

    init(sectionStartPos: CGFloat,
         sectionEndPos: CGFloat,
         startCellIndex: Int,
         sectionIndex: Int,
         debugName: String) {
        self.sectionStartPos = sectionStartPos
        self.sectionEndPos = sectionEndPos
        self.startCellIndex = startCellIndex
        self.sectionIndex = sectionIndex
        self.debugName = debugName
    }

    func withinRange(pos: CGFloat) -> Bool {
        return pos >= sectionStartPos && pos < sectionEndPos
    }
}

final class StoreDetailViewModel: PresentableViewModel {

    struct UIStats {
        static let leadingSpace: CGFloat = 16
    }

    private let service: SearchStoreDetailAPIService
    private let storeID: String
    private var store: StoreViewModel?
    private var storeMenus: [StoreMenuViewModel] = []

    var sectionData: [ListDiffable] = []
    var menuControls: [StoreDetailMenuSectionControlModel] = []
    var heightForOverallSection: CGFloat = 0

    init(service: SearchStoreDetailAPIService, storeID: String) {
        self.service = service
        self.storeID = storeID
    }

    func generateSectionData() {
        guard let store = store, let menu = storeMenus.first else {
            return
        }
        let storeOverviewModel = StoreDetailOverviewPresentingModel(
            name: store.businessNameDisplay,
            storeDescription: store.priceRangeDisplay + " " + store.storeDescriptionDisplay,
            rating: store.model.averageRating,
            ratingDisplay: store.ratingPreciseDescription,
            deliveryFee: store.costDisplayShort,
            deliveryTime: String(store.model.deliveryMinutes),
            deliveryDistance: store.distanceFromConsumer,
            offerPickUp: store.model.offersPickup
        )
        sectionData.append(storeOverviewModel)
        sectionData.append(StoreDetailSwitchMenuPresentingModel())
        var sectionItems: [StoreDetailMenuItemModel] = []
        var heightRecord: CGFloat = 0
        var cellIndex: Int = 0
        for (i, category) in menu.categories.enumerated() {
            var sectionHeight: CGFloat = heightRecord
            let categoryDescription: String? = (category.descriptionDisplay?.isEmpty ?? true) ? nil : category.descriptionDisplay
            let headerModel = StoreDetailMenuItemModel(
                type: .menuSectionHeader,
                sectionHeader: StoreDetailMenuHeaderPresentingModel(
                    title: category.categoryNameDisplay,
                    sectionDescription: categoryDescription
                )
            )
            sectionHeight += StoreDetailViewModel.getSizeForModel(item: headerModel).height
            sectionItems.append(headerModel)
            sectionItems.append(contentsOf: category.items.map { item in
                var itemDescription: String? = item.itemDescriptionDisplay
                if itemDescription == "" {
                    itemDescription = nil
                }
                let model = StoreDetailMenuItemModel(
                    type: .menuItem,
                    menuItem: StoreDetailMenuItemPresentingModel(
                        name: item.nameDisplay,
                        itemDescription: itemDescription,
                        imageURL: item.imageURL,
                        price: item.priceDisplay,
                        popularTag: nil
                    )
                )
                sectionHeight += StoreDetailViewModel.getSizeForModel(item: model).height
                return model
            })
            let separatorModel = StoreDetailMenuItemModel(type: .separator)
            sectionHeight += StoreDetailViewModel.getSizeForModel(item: separatorModel).height
            sectionItems.append(separatorModel)
            menuControls.append(StoreDetailMenuSectionControlModel(
                sectionStartPos: heightRecord,
                sectionEndPos: sectionHeight,
                startCellIndex: cellIndex,
                sectionIndex: i,
                debugName: category.categoryNameDisplay))
            print("Start: \(heightRecord)")
            print("End: \(sectionHeight)")
            cellIndex = sectionItems.count
            heightRecord = sectionHeight
        }
        sectionData.append(StoreDetailMenuPresentingModel(
            menuTitles: menu.menuTitles, menuItemModels: sectionItems)
        )
        heightForOverallSection = getHeightForStoreOverallInfo()
    }

    func fetchStore(completion: @escaping (String?) -> ()) {
        let tasks = DispatchGroup()
        var mostRecentErrorMsg: String = "Something went wrong."
        tasks.enter()
        var taskSucceeds = true
        fetchStoreOverview { (errorMsg) in
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                mostRecentErrorMsg = errorMsg
                taskSucceeds = false
            }
            tasks.leave()
        }
        tasks.enter()
        fetchStoreMenu { (errorMsg) in
            if let errorMsg = errorMsg {
                log.error(errorMsg)
                mostRecentErrorMsg = errorMsg
                taskSucceeds = false
            }
            tasks.leave()
        }
        tasks.notify(queue: .main) {
            if taskSucceeds {
                self.generateSectionData()
                completion(nil)
            } else {
                completion(mostRecentErrorMsg)
            }
        }
    }

    func fetchStoreOverview(completion: @escaping (String?) -> ()) {
        let request = FetchStoreOverviewRequestModel(storeID: storeID)
        service.fetchStoreOverview(request: request) { (store, error) in
            if let error = error as? SearchStoreDetailAPIServiceError {
                completion(error.errorMessage)
                return
            }
            guard let store = store else {
                completion("WTF? No store returning")
                return
            }
            self.store = StoreViewModel(store: store)
            completion(nil)
        }
    }

    func fetchStoreMenu(completion: @escaping (String?) -> ()) {
        let request = FetchStoreMenuRequestModel(storeID: storeID, type: .fullVersion)
        service.fetchStoreMenu(request: request) { (menus, error) in
            if let error = error as? SearchStoreDetailAPIServiceError {
                completion(error.errorMessage)
                return
            }
            guard menus.count > 0 else {
                completion("WTF? Menus are empty??")
                return
            }
            menus.forEach { menu in
                self.storeMenus.append(StoreMenuViewModel(menu: menu))
            }
            completion(nil)
        }
    }
}

extension StoreDetailViewModel {

    static func getSizeForModel(item: StoreDetailMenuItemModel) -> CGSize {
        let collectionViewWidth = UIScreen.main.bounds.width
        let containerWidth = collectionViewWidth - 2 * StoreDetailViewModel.UIStats.leadingSpace
        let height: CGFloat
        switch item.type {
        case .menuSectionHeader:
            let descriptionHeight = HelperManager.textHeight(
                item.sectionHeader?.sectionDescription,
                width: containerWidth,
                font: StoreDetailMenuHeaderCell.descriptionLabelFont)
            height = descriptionHeight + StoreDetailMenuHeaderCell.heightWithoutDescription
        case .menuItem:
            height = getHeightForMenuItem(containerWidth: containerWidth, model: item)
        case .separator:
            height = StoreDetailMenuSeparatorCell.height
        }
        return CGSize(width: collectionViewWidth, height: height)
    }

    static func getHeightForMenuItem(containerWidth: CGFloat,
                                     model: StoreDetailMenuItemModel) -> CGFloat {
        guard let item = model.menuItem else {
            return 0
        }
        let imageViewHeight = StoreDetailMenuItemCell.menuItemImageViewHeight
        let descriptionHeight = HelperManager.textHeight(
            item.itemDescription,
            width: containerWidth,
            font: StoreDetailMenuItemCell.descriptionLabelFont
        )
        var baseHeight = 24 + imageViewHeight + 12 + 15 + 4 + 20 + 6 + descriptionHeight + 6 + 20 + 16
        if item.imageURL == nil {
            baseHeight = baseHeight - imageViewHeight - 16
        }
        if item.popularTag == nil {
            baseHeight = baseHeight - 15
        }
        if item.itemDescription == nil {
            baseHeight = baseHeight - descriptionHeight
        }
        return baseHeight
    }

    func getHeightForStoreOverallInfo() -> CGFloat {
        guard let store = store else {
            return 0
        }
        let collectionViewWidth = UIScreen.main.bounds.width
        let containerWidth = collectionViewWidth - 2 * StoreDetailViewModel.UIStats.leadingSpace
        let nameHeight = HelperManager.textHeight(
            store.businessNameDisplay,
            width: containerWidth,
            font: StoreDetailOverviewCell.nameFont
        )
        let descriptionHeight = HelperManager.textHeight(
            store.storeDescriptionDisplay,
            width: containerWidth,
            font: StoreDetailOverviewCell.descriptionFont
        )
        let result = StoreDetailOverviewCell.heightWithoutLabels + nameHeight + descriptionHeight + StoreDetailDeliveryInfoCell.height + StoreDetailSwitchMenuCell.height
        return result
    }
}
