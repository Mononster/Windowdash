//
//  CartViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-10.
//  Copyright © 2018 Monster. All rights reserved.
//

final class CartViewModel {

    let model: Cart
    var storeID: String?
    var storeDisplayName: String?
    var totalItems: Int = 0
    var storeNameDisplay: String = ""
    var quantityDisplay: String = ""
    var taxAndFeeDetailDisplay: String = ""
    var isEmptyCart: Bool = true
    var subTotalPriceDisplay: String
    var taxAndFeePriceDisplay: String
    var deliveryPirceDisplay: String
    var totalBeforeTaxDisplay: String
    var deliveryTimeDisplay: String = ""

    var isPromoApplied: Bool = false
    var promoHintsTitle: String?

    init(model: Cart) {
        self.model = model
        subTotalPriceDisplay = model.subTotalMoney.displayString
        let taxAndFeesMoney = model.taxAmountMoney.money + model.serviceFeeMoney.money + model.minOrderFeeMoney.money
        taxAndFeePriceDisplay = taxAndFeesMoney.toFloatString()
        deliveryPirceDisplay = model.deliveryMoney.displayString
        totalBeforeTaxDisplay = model.totalBeforeTipMoney.displayString
        if let cents = model.deliveryFeeDetails?.discount?.amount.money.cents, cents != 0{
            isPromoApplied = true
            deliveryPirceDisplay = model.deliveryFeeDetails?.discount?.amount.displayString ?? ""
        }
        setup(model: model)
    }

    func setup(model: Cart) {
        //TODO: Identify the correct behaviors for ordering from multiple stores
        //Now just assume it always takes the first store.
        guard let orderCart = model.storeOrderCarts.first else {
            return
        }
        storeDisplayName = orderCart.store.name
        storeID = String(orderCart.store.id)
        for promo in orderCart.store.merchantPromotions {
            if promo.deliveryFee.cents == 0
                && model.subTotalMoney.money.cents < promo.minimumOrderCartSubtotal.cents {
                let neededMoneyToGetPromo = Money(
                    cents: promo.minimumOrderCartSubtotal.cents - model.subTotalMoney.money.cents
                )
                promoHintsTitle = "Add \(neededMoneyToGetPromo.toFloatString()) to get free delivery"
            }
        }
        for order in orderCart.orderDetails {
            for item in order.orderItems {
                totalItems += item.quantity
            }

        }
        isEmptyCart = (orderCart.orderDetails.first?.orderItems.count ?? 0) == 0
        let itemDescription = totalItems == 1 ? "item" : "items"
        storeNameDisplay = "\(storeDisplayName ?? "")"
        quantityDisplay = "\(totalItems) \(itemDescription)"

        taxAndFeeDetailDisplay = "Tax: \(model.taxAmountMoney.displayString)\nService Fee: \(model.serviceFeeMoney.displayString)\n\n\(model.serviceRateDetails?.message ?? "")"

        if model.deliveryAvailability?.asapAvailable ?? false {
            deliveryTimeDisplay = "ASAP"
            if let rangeA = model.deliveryAvailability?.asapMinutesRange?[safe: 0],
                let rangeB = model.deliveryAvailability?.asapMinutesRange?[safe: 1] {
                deliveryTimeDisplay += " (" + String(rangeA) + " - " + String(rangeB) + "mins)"
            }
        } else {
            deliveryTimeDisplay = "Choose delivery time"
        }
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
