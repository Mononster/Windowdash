//
//  OrderCartViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-11.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class OrderCartViewModel: PresentableViewModel {

    var cartViewModel: CartViewModel?

    var sectionData: [ListDiffable] = []

    private func generateData() {
        for orderCart in cartViewModel?.model.storeOrderCarts ?? []{
            for order in orderCart.orderDetails {
                for item in order.orderItems {
                    var optionsDisplayString: String?
                    for (i, extraOption) in item.itemExtraOptions.enumerated() {
                        optionsDisplayString = (optionsDisplayString ?? "")
                            + extraOption.name
                            + (i == item.itemExtraOptions.count  - 1 ? "" : ", ")
                    }
                    sectionData.append(OrderCartItemPresentingModel(
                        itemID: item.id,
                        itemName: item.itemName,
                        itemOptions: optionsDisplayString,
                        price: item.unitPriceMonetaryFields.displayString,
                        quantity: String(item.quantity))
                    )
                }
            }
        }
    }

    func fetchCurrentCart(completion: @escaping (String?) -> ()) {
        ApplicationDependency.manager.cartManager.fetchCurrentCart(completion: { (cartVM, errorMsg) in
            if let error = errorMsg {
                completion(error)
                return
            }
            guard let cartVM = cartVM else {
                completion("WTF NO CARTVM?")
                return
            }
            self.cartViewModel = cartVM
            cartVM.printInfo()
            self.generateData()
            completion(nil)
        })
    }
}
