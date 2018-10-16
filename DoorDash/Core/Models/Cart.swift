//
//  Cart.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-09.
//  Copyright © 2018 Monster. All rights reserved.
//

enum CartTipSuggestionValueType: String {
    case amount = "amount"
    case percentage = "percentage"
}

struct CartTipSuggestion: Codable {
    enum CarTipSuggestionCodingKeys: String, CodingKey {
        case values
        case defaultIndex = "default_index"
        case type
    }

    let tipValues: [Int64]
    let defaultIndex: Int
    let type: CartTipSuggestionValueType

    init(tipValues: [Int64], defaultIndex: Int, type: CartTipSuggestionValueType) {
        self.tipValues = tipValues
        self.defaultIndex = defaultIndex
        self.type = type
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CarTipSuggestionCodingKeys.self)
        let tipValues: [Int64] = try values.decodeIfPresent([Int64].self, forKey: .values) ?? []
        let defaultIndex: Int = try values.decodeIfPresent(Int.self, forKey: .defaultIndex) ?? 0
        let typeRaw: String = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.init(tipValues: tipValues,
                  defaultIndex: defaultIndex,
                  type: CartTipSuggestionValueType(rawValue: typeRaw) ?? .amount)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartServiceRateDetails: Codable {
    enum CartServiceRateDetailsCodingKeys: String, CodingKey {
        case finalFee = "final_fee"
        case message
        case finalRate = "final_rate"
    }

    let message: String?
    let finalFee: MonetaryField
    let finalRate: String

    init(message: String?, finalFee: MonetaryField, finalRate: String) {
        self.message = message
        self.finalFee = finalFee
        self.finalRate = finalRate
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CartServiceRateDetailsCodingKeys.self)
        let money = try values.decodeIfPresent(MonetaryField.self, forKey: .finalFee) ?? MonetaryField()
        let finalRate: String = try values.decodeIfPresent(String.self, forKey: .finalRate) ?? ""
        let message: String? = try values.decodeIfPresent(String.self, forKey: .message)
        self.init(message: message,
                  finalFee: money,
                  finalRate: finalRate)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartStoreOverview: Codable {
    enum CartStoreOverviewCodingKeys: String, CodingKey {
        case id
        case name
        case merchantPromotions = "merchant_promotions"
    }

    let id: Int64
    let name: String
    let merchantPromotions: [CartStoreMerchantPromotion]

    init(id: Int64,
         name: String,
         merchantPromotions: [CartStoreMerchantPromotion]) {
        self.id = id
        self.name = name
        self.merchantPromotions = merchantPromotions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CartStoreOverviewCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let name: String = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        let promotions: [CartStoreMerchantPromotion] = try values.decodeIfPresent(
            [CartStoreMerchantPromotion].self, forKey: .merchantPromotions
        ) ?? []
        self.init(id: id, name: name, merchantPromotions: promotions)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartStoreMerchantPromotion: Codable {
    enum MerchantPromotionCodingKeys: String, CodingKey {
        case minimumOrderCartSubtotal = "minimum_order_cart_subtotal"
        case newStoreCustomersOnly = "new_store_customers_only"
        case deliveryFee = "delivery_fee"
        case id
    }

    let id: Int64
    let minimumOrderCartSubtotal: Money
    let newStoreCustomersOnly: Bool
    let deliveryFee: Money

    init(id: Int64,
         minimumOrderCartSubtotal: Money,
         newStoreCustomersOnly: Bool,
         deliveryFee: Money) {
        self.id = id
        self.minimumOrderCartSubtotal = minimumOrderCartSubtotal
        self.newStoreCustomersOnly = newStoreCustomersOnly
        self.deliveryFee = deliveryFee
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MerchantPromotionCodingKeys.self)
        let minimumOrderCartSubtotalCents: Int64 = try values.decodeIfPresent(Int64.self, forKey: .minimumOrderCartSubtotal) ?? 0
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let newStoreCustomersOnly: Bool = try values.decodeIfPresent(Bool.self, forKey: .newStoreCustomersOnly) ?? true
        let deliveryFeeCents: Int64 = try values.decodeIfPresent(Int64.self, forKey: .deliveryFee) ?? 0
        self.init(id: id,
                  minimumOrderCartSubtotal: Money(cents: minimumOrderCartSubtotalCents, currency: .USD),
                  newStoreCustomersOnly: newStoreCustomersOnly,
                  deliveryFee: Money(cents: deliveryFeeCents, currency: .USD))
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartDeliveryFeeDetails: Codable {

    enum DeliveryFeeDetailsCodingKeys: String, CodingKey {
        case discount
        case finalFee = "final_fee"
    }

    struct DeliveryDiscount: Codable {
        enum DiscountCodingKeys: String, CodingKey {
            case sourceType = "source_type"
            case description
            case text
            case amount
            case minSubtotal = "min_subtotal"
        }

        let sourceType: String?
        let text: String?
        let discountDiscription: String?
        let amount: MonetaryField
        let minSubtotal: MonetaryField

        init(sourceType: String?,
             text: String?,
             discountDiscription: String?,
             amount: MonetaryField,
             minSubtotal: MonetaryField) {
            self.sourceType = sourceType
            self.text = text
            self.discountDiscription = discountDiscription
            self.amount = amount
            self.minSubtotal = minSubtotal
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: DiscountCodingKeys.self)
            let amountMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .amount) ?? MonetaryField()
            let minSubtotal: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .minSubtotal) ?? MonetaryField()
            let sourceType: String? = try values.decodeIfPresent(String.self, forKey: .sourceType)
            let text: String? = try values.decodeIfPresent(String.self, forKey: .text)
            let discountDiscription: String? = try values.decodeIfPresent(String.self, forKey: .description)
            self.init(sourceType: sourceType,
                      text: text,
                      discountDiscription: discountDiscription,
                      amount: amountMoney,
                      minSubtotal: minSubtotal)
        }

        func encode(to encoder: Encoder) throws {}
    }

    let finalFee: MonetaryField
    let discount: DeliveryDiscount?

    init(finalFee: MonetaryField,
         discount: DeliveryDiscount?) {
        self.finalFee = finalFee
        self.discount = discount
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DeliveryFeeDetailsCodingKeys.self)
        let finalFee: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .finalFee) ?? MonetaryField()
        let discount: DeliveryDiscount? = try values.decodeIfPresent(DeliveryDiscount.self, forKey: .discount)
        self.init(finalFee: finalFee, discount: discount)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartDeliveryAvailability: Codable {
    enum DeliveryAvailabilityCodingKeys: String, CodingKey {
        case asapPickupAvailable = "asap_pickup_available"
        case asapAvailable = "asap_available"
        case asapPickupMinutesRange = "asap_pickup_minutes_range"
        case asapMinutesRange = "asap_minutes_range"
    }

    let asapPickupAvailable: Bool
    let asapAvailable: Bool
    let asapPickupMinutesRange: [Int]?
    let asapMinutesRange: [Int]?

    init(asapPickupAvailable: Bool,
         asapAvailable: Bool,
         asapPickupMinutesRange: [Int]?,
         asapMinutesRange: [Int]?) {
        self.asapPickupAvailable = asapPickupAvailable
        self.asapAvailable = asapAvailable
        self.asapPickupMinutesRange = asapPickupMinutesRange
        self.asapMinutesRange = asapMinutesRange
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DeliveryAvailabilityCodingKeys.self)
        let asapPickupAvailable: Bool = try values.decodeIfPresent(Bool.self, forKey: .asapPickupAvailable) ?? false
        let asapAvailable: Bool = try values.decodeIfPresent(Bool.self, forKey: .asapAvailable) ?? false
        let asapPickupMinutesRange: [Int]? = try values.decodeIfPresent([Int].self, forKey: .asapPickupMinutesRange)
        let asapMinutesRange: [Int]? = try values.decodeIfPresent([Int].self, forKey: .asapMinutesRange)
        self.init(asapPickupAvailable: asapPickupAvailable,
                  asapAvailable: asapAvailable,
                  asapPickupMinutesRange: asapPickupMinutesRange,
                  asapMinutesRange: asapMinutesRange)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartOrderItem: Codable {
    enum OrderItemCodingKeys: String, CodingKey {
        case id
        case item
        case quantity
        case unitPriceMonetaryFields = "unit_price_monetary_fields"
        case options
    }

    enum ItemInfoCodingKeys: String, CodingKey {
        case id
        case name
        case priceMonetaryFields = "price_monetary_fields"
    }

    struct OrderItemOption: Codable {
        enum OrderItemOptionCodingKeys: String, CodingKey {
            case itemExtraOption = "item_extra_option"
            case quantity
        }

        enum OrderItemExtraOptionCodingKeys: String, CodingKey {
            case id
            case name
            case priceMonetaryFields = "price_monetary_fields"
        }

        let optionID: Int64
        let quantity: Int
        let name: String
        let price: MonetaryField

        init(optionID: Int64,
             quantity: Int,
             name: String,
             price: MonetaryField) {
            self.optionID = optionID
            self.quantity = quantity
            self.name = name
            self.price = price
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: OrderItemOptionCodingKeys.self)
            let quantity: Int = try values.decode(Int.self, forKey: .quantity)
            let extraOptionContainer = try values.nestedContainer(keyedBy: OrderItemExtraOptionCodingKeys.self, forKey: .itemExtraOption)
            let priceMonetaryFields: MonetaryField = try extraOptionContainer.decodeIfPresent(
                MonetaryField.self, forKey: .priceMonetaryFields
                ) ?? MonetaryField()
            let name: String = try extraOptionContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
            let optionID: Int64 = try extraOptionContainer.decode(Int64.self, forKey: .id)
            self.init(optionID: optionID, quantity: quantity, name: name, price: priceMonetaryFields)
        }

        func encode(to encoder: Encoder) throws {}
    }

    let itemUpdateID: Int64
    let itemID: Int64
    let quantity: Int
    let unitPriceMonetaryFields: MonetaryField
    let itemBasePriceMonetaryFields: MonetaryField
    let itemName: String
    let itemExtraOptions: [OrderItemOption]

    init(itemUpdateID: Int64,
         itemID: Int64,
         quantity: Int,
         unitPriceMonetaryFields: MonetaryField,
         itemBasePriceMonetaryFields: MonetaryField,
         itemName: String,
         itemExtraOptions: [OrderItemOption]) {
        self.itemUpdateID = itemUpdateID
        self.itemID = itemID
        self.quantity = quantity
        self.unitPriceMonetaryFields = unitPriceMonetaryFields
        self.itemBasePriceMonetaryFields = itemBasePriceMonetaryFields
        self.itemName = itemName
        self.itemExtraOptions = itemExtraOptions
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: OrderItemCodingKeys.self)
        let quantity: Int = try values.decode(Int.self, forKey: .quantity)
        let itemUpdateID: Int64 = try values.decode(Int64.self, forKey: .id)
        let itemContainer = try values.nestedContainer(keyedBy: ItemInfoCodingKeys.self, forKey: .item)
        let itemID: Int64 = try itemContainer.decode(Int64.self, forKey: .id)
        let itemBasePriceMonetaryFields: MonetaryField = try itemContainer.decodeIfPresent(
            MonetaryField.self, forKey: .priceMonetaryFields
            ) ?? MonetaryField()
        let unitPriceMonetaryFields: MonetaryField = try values.decodeIfPresent(
            MonetaryField.self, forKey: .unitPriceMonetaryFields
            ) ?? MonetaryField()
        let itemName: String = try itemContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
        let itemExtraOptions: [OrderItemOption] = try values.decodeIfPresent([OrderItemOption].self, forKey: .options) ?? []
        self.init(itemUpdateID: itemUpdateID,
                  itemID: itemID,
                  quantity: quantity,
                  unitPriceMonetaryFields: unitPriceMonetaryFields,
                  itemBasePriceMonetaryFields: itemBasePriceMonetaryFields,
                  itemName: itemName,
                  itemExtraOptions: itemExtraOptions)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartOrderDetail: Codable {
    enum OrderDetailCodigKeys: String, CodingKey {
        case orderItems = "order_items"
        case consumer
    }

    enum OrderConsumerCodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }

    let orderItems: [CartOrderItem]
    let consumerFirstName: String?
    let consumerLastName: String?
    let consumerID: Int64

    init(orderItems: [CartOrderItem],
         consumerFirstName: String?,
         consumerLastName: String?,
         consumerID: Int64) {
        self.orderItems = orderItems
        self.consumerFirstName = consumerFirstName
        self.consumerLastName = consumerLastName
        self.consumerID = consumerID
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: OrderDetailCodigKeys.self)
        let orderItems: [CartOrderItem] = try values.decodeIfPresent([CartOrderItem].self, forKey: .orderItems) ?? []
        let consumerContainer = try values.nestedContainer(keyedBy: OrderConsumerCodingKeys.self, forKey: .consumer)
        let consumerID: Int64 = try consumerContainer.decode(Int64.self, forKey: .id)
        let firstName: String? = try consumerContainer.decodeIfPresent(String.self, forKey: .firstName)
        let lastName: String? = try consumerContainer.decodeIfPresent(String.self, forKey: .lastName)
        self.init(orderItems: orderItems, consumerFirstName: firstName, consumerLastName: lastName, consumerID: consumerID)
    }

    func encode(to encoder: Encoder) throws {}
}

struct CartStoreOrder: Codable {
    enum StoreOrderCodingKeys: String, CodingKey {
        case id
        case store
        case orders
        case isConsumerPickup = "is_consumer_pickup"
    }

    let id: Int64
    let isConsumerPickup: Bool
    let store: CartStoreOverview
    let orderDetails: [CartOrderDetail]

    init(id: Int64,
         isConsumerPickup: Bool,
         store: CartStoreOverview,
         orderDetails: [CartOrderDetail]) {
        self.id = id
        self.isConsumerPickup = isConsumerPickup
        self.store = store
        self.orderDetails = orderDetails
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: StoreOrderCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let isConsumerPickup: Bool = try values.decodeIfPresent(Bool.self, forKey: .isConsumerPickup) ?? false
        let store: CartStoreOverview = try values.decode(CartStoreOverview.self, forKey: .store)
        let orderDetails: [CartOrderDetail] = try values.decodeIfPresent([CartOrderDetail].self, forKey: .orders) ?? []
        self.init(id: id,
                  isConsumerPickup: isConsumerPickup,
                  store: store,
                  orderDetails: orderDetails)
    }

    func encode(to encoder: Encoder) throws {}
}

struct Cart: Codable {

    enum CartCodingKeys: String, CodingKey {
        case id
        case totalBeforeTipMonetaryFields = "total_before_tip_monetary_fields"
        case minOrderSubtotalMonetaryFields = "min_order_subtotal_monetary_fields"
        case minOrderFeeMonetaryFields = "min_order_fee_monetary_fields"
        case taxAmountMonetaryFields = "tax_amount_monetary_fields"
        case deliveryMonetaryFields = "delivery_fee_monetary_fields"
        case subTotalMonetaryFields = "subtotal_monetary_fields"
        case tipSuggestions = "tip_suggestions"
        case serviceRateDetails = "service_rate_details"
        case serviceFeeMonetaryFields = "service_fee_monetary_fields"
        case storeOrderCarts = "store_order_carts"
        case deliveryAvailability = "delivery_availability"
        case deliveryFeeDetails = "delivery_fee_details"
    }

    let id: Int64
    let totalBeforeTipMoney: MonetaryField
    let minOrderSubtotalMoney: MonetaryField
    let minOrderFeeMoney: MonetaryField
    let taxAmountMoney: MonetaryField
    let serviceFeeMoney: MonetaryField
    let deliveryMoney: MonetaryField
    let subTotalMoney: MonetaryField

    let tipSuggestions: CartTipSuggestion?
    let serviceRateDetails: CartServiceRateDetails?
    let storeOrderCarts: [CartStoreOrder]
    let deliveryAvailability: CartDeliveryAvailability?
    let deliveryFeeDetails: CartDeliveryFeeDetails?

    init(id: Int64,
         totalBeforeTipMoney: MonetaryField,
         minOrderSubtotalMoney: MonetaryField,
         minOrderFeeMoney: MonetaryField,
         taxAmountMoney: MonetaryField,
         deliveryMoney: MonetaryField,
         serviceFeeMoney: MonetaryField,
         subTotalMoney: MonetaryField,
         tipSuggestions: CartTipSuggestion?,
         serviceRateDetails: CartServiceRateDetails?,
         storeOrderCarts: [CartStoreOrder],
         deliveryAvailability: CartDeliveryAvailability?,
         deliveryFeeDetails: CartDeliveryFeeDetails?) {
        self.id = id
        self.totalBeforeTipMoney = totalBeforeTipMoney
        self.minOrderSubtotalMoney = minOrderSubtotalMoney
        self.minOrderFeeMoney = minOrderFeeMoney
        self.taxAmountMoney = taxAmountMoney
        self.deliveryMoney = deliveryMoney
        self.serviceFeeMoney = serviceFeeMoney
        self.subTotalMoney = subTotalMoney
        self.tipSuggestions = tipSuggestions
        self.serviceRateDetails = serviceRateDetails
        self.storeOrderCarts = storeOrderCarts
        self.deliveryAvailability = deliveryAvailability
        self.deliveryFeeDetails = deliveryFeeDetails
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CartCodingKeys.self)
        let id: Int64 = try values.decode(Int64.self, forKey: .id)
        let totalBeforeTipMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .totalBeforeTipMonetaryFields) ?? MonetaryField()
        let minOrderSubtotalMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .minOrderSubtotalMonetaryFields) ?? MonetaryField()
        let minOrderFeeMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .minOrderFeeMonetaryFields) ?? MonetaryField()
        let taxAmountMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .taxAmountMonetaryFields) ?? MonetaryField()
        let deliveryMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .deliveryMonetaryFields) ??   MonetaryField()
        let subTotalMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .subTotalMonetaryFields) ?? MonetaryField()
        let serviceFeeMoney: MonetaryField = try values.decodeIfPresent(MonetaryField.self, forKey: .serviceFeeMonetaryFields) ?? MonetaryField()
        let tipSuggestions: CartTipSuggestion? = try values.decodeIfPresent(CartTipSuggestion.self, forKey: .tipSuggestions)
        let serviceRateDetails: CartServiceRateDetails? = try values.decodeIfPresent(CartServiceRateDetails.self, forKey: .serviceRateDetails)
        let storeOrderCarts: [CartStoreOrder] = try values.decodeIfPresent([CartStoreOrder].self, forKey: .storeOrderCarts) ?? []
        let deliveryAvailability: CartDeliveryAvailability? = try values.decodeIfPresent(CartDeliveryAvailability.self, forKey: .deliveryAvailability)
        let deliveryFeeDetails: CartDeliveryFeeDetails? = try values.decodeIfPresent(CartDeliveryFeeDetails.self, forKey: .deliveryFeeDetails)
        self.init(id: id,
                  totalBeforeTipMoney: totalBeforeTipMoney,
                  minOrderSubtotalMoney: minOrderSubtotalMoney,
                  minOrderFeeMoney: minOrderFeeMoney,
                  taxAmountMoney: taxAmountMoney,
                  deliveryMoney: deliveryMoney,
                  serviceFeeMoney: serviceFeeMoney,
                  subTotalMoney: subTotalMoney,
                  tipSuggestions: tipSuggestions,
                  serviceRateDetails: serviceRateDetails,
                  storeOrderCarts: storeOrderCarts,
                  deliveryAvailability: deliveryAvailability,
                  deliveryFeeDetails: deliveryFeeDetails)
    }

    func encode(to encoder: Encoder) throws {}
}
