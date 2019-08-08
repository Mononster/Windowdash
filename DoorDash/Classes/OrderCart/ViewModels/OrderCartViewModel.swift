//
//  OrderCartViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class OrderCartViewModel: PresentableViewModel {

    enum UIStats: CGFloat {
        case leadingSpace = 40
        case trailingSpace = 16
    }

    var cartViewModel: CartViewModel?

    var sectionData: [ListDiffable] = []

    private func generateData() {
        guard let viewModel = cartViewModel else {
            return
        }
        self.sectionData.removeAll()
        for orderCart in viewModel.model.storeOrderCarts {
            for order in orderCart.orderDetails {
                for item in order.orderItems {
                    var optionsDisplayString: String?
                    for (i, extraOption) in item.itemExtraOptions.enumerated() {
                        optionsDisplayString = (optionsDisplayString ?? "")
                            + extraOption.name
                            + (i == item.itemExtraOptions.count  - 1 ? "" : ", ")
                    }
                    sectionData.append(OrderCartItemPresentingModel(
                        itemID: item.itemID,
                        itemRemoveID: item.itemUpdateID,
                        itemName: item.itemName,
                        itemOptions: optionsDisplayString,
                        price: item.unitPriceMonetaryFields.displayString,
                        quantity: String(item.quantity))
                    )
                }
            }
        }
        if sectionData.isEmpty {
            sectionData.append(OrderCartEmptyDataPresentingModel(title: "Your cart is empty"))
            return
        }
        sectionData.append(OrderCartAddMoreItemsPresentingModel(title: "Add More Item"))
        sectionData.append(OrderCartPromoCodePresentingModel(title: "Promo Code"))
        let priceDisplays = [
            ("Subtotal", viewModel.subTotalPriceDisplay, false),
            ("Tax and Fees", viewModel.taxAndFeePriceDisplay, true),
            ("Delivery", viewModel.deliveryPirceDisplay, false)
        ]

        sectionData.append(OrderCartPriceDisplayPresentingModel(
            priceDisplays: priceDisplays,
            promoUsedOnDelivery: viewModel.isPromoApplied,
            taxAndFeeDetail: viewModel.taxAndFeeDetailDisplay,
            promoHintTitle: viewModel.promoHintsTitle,
            promoDetail: nil)
        )
    }


    /// Fetch current cart
    ///
    /// - Parameter completion: error message and is the cart empty.
    func fetchCurrentCart(completion: @escaping (String?, Bool) -> ()) {
        ApplicationDependency.manager.cartManager.fetchCurrentCart(completion: { (cartVM, errorMsg) in
            if let error = errorMsg {
                completion(error, true)
                return
            }
            guard let cartVM = cartVM else {
                completion("WTF NO CARTVM?", true)
                return
            }
            self.cartViewModel = cartVM
            self.generateData()
            completion(nil, self.sectionData.count == 1)
        })
    }

    func removeItem(id: Int64, completion: @escaping (String?) -> ()) {
        ApplicationDependency.manager.cartManager.removeItemFromCart(id: id) { errorMsg in
            completion(errorMsg)
        }
    }

    func generateItemSelectedData(itemID: Int64) -> ItemSelectedData? {
        guard let viewModel = cartViewModel else {
            return nil
        }
        var quantity: Int = 1
        var selectedOptionIDs: [Int64] = []
        var itemUpdateID: Int64 = 0
        for orderCart in viewModel.model.storeOrderCarts {
            for order in orderCart.orderDetails {
                for item in order.orderItems {
                    guard item.itemID == itemID else {
                        continue
                    }
                    itemUpdateID = item.itemUpdateID
                    quantity = item.quantity
                    selectedOptionIDs = item.itemExtraOptions.map { option in
                        return option.optionID
                    }
                }
            }
        }
        return ItemSelectedData(
            itemUpdateID: itemUpdateID,
            optionIDs: selectedOptionIDs,
            quantity: quantity,
            instructions: nil
        )
    }
}
