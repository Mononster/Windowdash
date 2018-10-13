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
    private var presentingExtraModels: [ItemDetailMultipleChoicePresentingModel] = []
    private var basePriceCents: Int64 = 0
    private var selectedQuantity: Int = 1

    let storeID: String
    var sectionData: [ListDiffable] = []
    var currentCartTotalDisplay: String = ""
    var specialInstruction: String = ""
    var headerImageList: IGPreviewPhotoList?
    var currentTotal: Money = Money.zero
    let addToOrderButtonDisplayTitle: String

    init(service: SearchStoreItemAPIService,
         itemID: String,
         storeID: String,
         mode: ItemDetailEntranceMode,
         selectedQuantity: Int = 1) {
        self.service = service
        self.itemID = itemID
        self.storeID = storeID
        self.addToOrderButtonDisplayTitle = mode == .fromCart ? "Update Item" : "Add to Order"
        self.selectedQuantity = selectedQuantity
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
        self.sectionData.append(ItemDetailSelectQuantityPresentingModel(quantity: selectedQuantity,
                                                                        maxQuantity: 99,
                                                                        minQuantity: 1))
    }

    private func generateMultipleChoices(item: MenuItemViewModel) {
        for extra in item.extras {
            let options: [ItemDetailOptionPresentingModel] = extra.options.map { option in
                return ItemDetailOptionPresentingModel(
                    id: option.model.id,
                    optionName: option.optionName,
                    priceCents: option.priceCents,
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

    // validate and retrun invalid section
    func validateAllExtras() -> Int? {
        for (i, model) in presentingExtraModels.enumerated() {
            if model.numSelectedOptions < model.minNumberOptions {
                return i
            }
        }
        return nil
    }

    func addItemToCart(completion: @escaping (String?) -> ()) {
        guard let cartID = ApplicationDependency.manager.cartManager.currentCartID else {
            log.error("WTF CAN'T FIND CART ID AT THIS POINT? => BUG")
            return
        }
        var options: [AddItemOptionRequestModel] = []
        for model in presentingExtraModels {
            let quantity = model.selectionMode == .singleSelect ? 0 : 1
            for option in model.options {
                if option.isSelected {
                    options.append(
                        AddItemOptionRequestModel(
                            id: option.id, quantity: quantity, nestedOptions: []
                        )
                    )
                }
            }
        }
        let request = AddItemToCartRequestModel(
            storeID: storeID,
            itemID: itemID,
            cartID: String(cartID),
            subsititutionMethod: .contactMe,
            quantity: selectedQuantity,
            options: options,
            specialInstructions: specialInstruction
        )
        CartAPIService().addItemToCart(request: request) { (error) in
            if let error = error as? APIServiceError {
                completion(error.errorMessage)
                return
            }
            completion(nil)
        }
    }

    func updateCurrentBalance(cents: Int64) {
        self.basePriceCents += cents
        self.currentTotal.cents += cents * Int64(selectedQuantity)
    }

    func updateQuantityAndBalance(newQuantity: Int) {
        self.selectedQuantity = newQuantity
        self.currentTotal.cents = basePriceCents * Int64(selectedQuantity)
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
            self.basePriceCents = item.price.money.cents
            self.currentTotal = item.price.money
            self.item = MenuItemViewModel(item: item)
            self.generateData()
            completion(nil)
        }
    }
}
