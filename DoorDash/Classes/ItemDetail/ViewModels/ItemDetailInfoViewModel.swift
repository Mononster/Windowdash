//
//  ItemDetailInfoViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-05.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

enum ItemDetailEntranceMode {
    case fromStore
    case fromCart
}

final class ItemDetailInfoViewModel: PresentableViewModel {

    enum UIStats: CGFloat {
        case leadingSpace = 16
    }

    private var item: MenuItemViewModel?
    private let service: SearchStoreItemAPIService
    private let itemID: String
    private let storeID: String
    private var presentingExtraModels: [ItemDetailMultipleChoicePresentingModel] = []

    var sectionData: [ListDiffable] = []
    var currentCartTotalDisplay: String = ""
    var headerImageList: IGPreviewPhotoList?
    var currentTotal: Money = Money.zero
    let addToOrderButtonDisplayTitle: String

    init(service: SearchStoreItemAPIService,
         itemID: String,
         storeID: String,
         mode: ItemDetailEntranceMode) {
        self.service = service
        self.itemID = itemID
        self.storeID = storeID
        self.addToOrderButtonDisplayTitle = mode == .fromCart ? "Update Item" : "Add to Order"
    }

    private func generateData() {
        guard let item = item else {
            return
        }
        if let imageURL = item.imageURL {
            self.headerImageList = IGPreviewPhotoList(photos: [PreviewPhoto(lowQualityURL: imageURL, highQualityURL: nil)])
        }
        self.sectionData.append(ItemDetailOverviewPresentingModel(
            name: item.nameDisplay,
            itemDescription: item.itemDescriptionDisplay,
            popularTag: item.isPopular ? "POPULAR" : nil)
        )
        generateMultipleChoices(item: item)
        self.sectionData.append(ItemDetailAddInstructionPresentingModel())
        self.sectionData.append(ItemDetailSelectQuantityPresentingModel(quantity: 1,
                                                                        maxQuantity: 4,
                                                                        minQuantity: 1))
    }

    private func generateMultipleChoices(item: MenuItemViewModel) {
        for extra in item.extras {
            let options: [ItemDetailOptionPresentingModel] = extra.options.map { option in
                return ItemDetailOptionPresentingModel(
                    optionName: option.optionName,
                    price: option.priceDisplay
                )
            }
            let presentingModel = ItemDetailMultipleChoicePresentingModel(
                mode: extra.model.selectionMode,
                name: extra.questionName,
                description: extra.questionDescription,
                isRequired: extra.isRequired,
                minNumberOptions: extra.model.minNumOptions,
                maxNumberOptions: extra.model.maxNumOptions,
                options: options
            )
            sectionData.append(presentingModel)
            presentingExtraModels.append(presentingModel)
        }
    }

    func validateAllExtras() -> Int? {
        return nil
    }

    func fetchItem(completion: @escaping (String?) -> ()) {
        let request = FetchStoreItemRequestModel(storeID: storeID, itemID: itemID)
        self.service.fetchStoreOverview(request: request) { (item, error) in
            if let error = error as? SearchStoreItemAPIServiceError  {
                completion(error.errorMessage)
                return
            }
            guard let item = item else {
                log.error("WTF NO ITEM?")
                completion("Something went wrong...")
                return
            }
            self.currentTotal = item.price
            self.item = MenuItemViewModel(item: item)
            self.generateData()
            completion(nil)
        }
    }
}
