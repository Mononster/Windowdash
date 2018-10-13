//
//  CartViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-10.
//  Copyright © 2018 Monster. All rights reserved.
//

final class CartViewModel {

    let model: Cart
    var storeDisplayName: String?
    var totalItems: Int = 0
    var storeNameAndQuantityDisplay: String = ""
    var isEmptyCart: Bool = true

    init(model: Cart) {
        self.model = model
        setup(model: model)
    }

    func setup(model: Cart) {
        //TODO: Identify the correct behaviors for ordering from multiple stores
        //Now just assume it always takes the first store.
        guard let orderCart = model.storeOrderCarts.first else {
            return
        }
        storeDisplayName = orderCart.store.name
        for order in orderCart.orderDetails {
            for item in order.orderItems {
                totalItems += item.quantity
            }
        }
        isEmptyCart = orderCart.orderDetails.count == 0
        let itemDescription = totalItems == 1 ? "item" : "items"
        storeNameAndQuantityDisplay = "\(storeDisplayName ?? "") (\(totalItems) \(itemDescription))"
    }

    func printInfo() {
        print("----------------Fees Detail--------------------")
        print("Delivery Fee: " + model.deliveryMoney.displayString)
        print("Tax Fee: " + model.taxAmountMoney.displayString)
        print("Service Final Fee: " + (model.serviceRateDetails?.finalFee.displayString ?? "Null"))
        print("Small Order Fee: " + model.minOrderFeeMoney.displayString)
        print("Total Before Tip Fee: " + model.totalBeforeTipMoney.displayString)
        print("Min Order Subtotal: " + model.minOrderSubtotalMoney.displayString)
        if model.storeOrderCarts.count > 0 {
            print("----------------Order Cart Detail--------------------")
        }
        for orderCart in model.storeOrderCarts {
            print("--Store Detail--")
            print("Store Name: " + orderCart.store.name)
            if orderCart.store.merchantPromotions.count > 0 {
                print("Promotions: ")
            }
            for promotion in orderCart.store.merchantPromotions {
                print("Minimum Order Cart Subtotal: " + promotion.minimumOrderCartSubtotal.toFloatString())
                print("Delivery Fee:: " + promotion.deliveryFee.toFloatString())
            }
            if orderCart.orderDetails.count > 0 {
                print("----------------Order Detail--------------------")
            }
            for order in orderCart.orderDetails {
                print("Consumer Info: ")
                print("-- First Name: " + (order.consumerFirstName ?? "N/A"))
                print("-- Last Name: " + (order.consumerLastName ?? "N/A"))
                for (i, item) in order.orderItems.enumerated() {
                    print("----\(i)----")
                    print("Item Name: " + item.itemName)
                    print("Item Price: " + item.unitPriceMonetaryFields.displayString)
                    print("Item Quantity: \(item.quantity)")
                    if item.itemExtraOptions.count > 0 {
                        print("---Extra Options For \(item.itemName)---")
                    }
                    for extraOption in item.itemExtraOptions {
                        print("Option Name: " + extraOption.name)
                        print("Quantity: \(extraOption.quantity)")
                        print("Price: " + extraOption.price.displayString)
                    }
                }
            }
        }
        print("----------------Tip Suggestions Detail--------------------")
        print("Tip Values: \(model.tipSuggestions?.tipValues ?? [])")
        print("Tip type: " + (model.tipSuggestions?.type.rawValue ?? "Null"))

        print("----------------Delivery Availability Detail--------------------")
        print("Delivery Asapn Rage: \(model.deliveryAvailability?.asapMinutesRange ?? [])")

        print("----------------Delivery Fee Details--------------------")
        print("Final Fee: " + (model.deliveryFeeDetails?.finalFee.displayString ?? "Null"))
        print("-- Discount: ")
        print("----------- SourceType: \(model.deliveryFeeDetails?.discount?.sourceType ?? "Null")")
        print("----------- Text: \(model.deliveryFeeDetails?.discount?.text ?? "Null")")
        print("----------- Amount: \(model.deliveryFeeDetails?.discount?.amount.displayString ?? "Null")")
    }
}
