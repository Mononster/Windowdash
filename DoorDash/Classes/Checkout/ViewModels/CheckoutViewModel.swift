//
//  CheckoutViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-14.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class CheckoutViewModel: PresentableViewModel {

    enum UIStats: CGFloat {
        case leadingSpace = 16
    }

    var cartViewModel: CartViewModel?
    var sectionData: [ListDiffable] = []

    var dasherTip: Money = .zero
    var dasherTipDefaultIndex: Int = 0
    var dasherTipSelections: [String] = []
    var totalFee: Money = .zero

    private func generateData() {
        guard let viewModel = cartViewModel,
            let user = ApplicationEnvironment.current.currentUser,
            let address = user.defaultAddress else {
            return
        }
        calcTipAmount(viewModel: viewModel)
        self.sectionData.removeAll()
        let userDefaultAddress = address.shortName
        let deliveryInstruction = address.driverInstructions ?? "Add"
        sectionData.append(CheckoutDeliveryDetailsPresentingModel(
            details: [
                CheckoutDeliveryDetailModel(
                    type: .map, subTitle: "", lat: address.latitude, lng: address.longitude),
                CheckoutDeliveryDetailModel(type: .address, subTitle: userDefaultAddress),
                CheckoutDeliveryDetailModel(type: .deliveryInstructions, subTitle: deliveryInstruction),
                CheckoutDeliveryDetailModel(type: .eta, subTitle: viewModel.deliveryTimeDisplay)
            ]
        ))
        generatePaymentSection()
    }

    func refreshPaymentSection() {
        sectionData.removeLast()
        generatePaymentSection()
    }

    func generatePaymentSection() {
        guard let user = ApplicationEnvironment.current.currentUser else {
            return
        }
        var cardTitle: String = "Add Card"
        if let card = user.defaultCard {
            cardTitle = PaymentMethodViewModel(model: card).displayTitle
        }
        sectionData.append(
            CheckoutPaymentPresentingModel(
                dasherTipValue: dasherTip.toFloatString(),
                dasherTips: dasherTipSelections,
                currentSelectedTipIndex: dasherTipDefaultIndex,
                cardInfo: cardTitle
            )
        )
    }

    func updateSelectedTipValue(index: Int) {
        guard index < dasherTipSelections.count else {
            return
        }
        sectionData.removeLast()
        updateAmountInfo(tipIndex: index)
        generatePaymentSection()
    }

    func calcTipAmount(viewModel: CartViewModel) {
        updateAmountInfo(tipIndex: viewModel.model.tipSuggestions?.defaultIndex ?? 0)
    }

    func updateAmountInfo(tipIndex: Int) {
        guard let viewModel = cartViewModel,
            let tipSuggestion = viewModel.model.tipSuggestions else {
            return
        }
        dasherTipSelections.removeAll()
        dasherTipDefaultIndex = tipIndex
        for value in tipSuggestion.tipValues {
            if tipSuggestion.type == .amount {
                dasherTipSelections.append(Money(cents: value).toFloatString())
            } else {
                dasherTipSelections.append(String(value) + "%")
            }
        }
        let defaultTipValue = tipSuggestion.tipValues[safe: tipIndex] ?? 0
        if tipSuggestion.type == .amount {
            self.dasherTip = Money(cents: defaultTipValue)
        } else {
            let percentage = Float(defaultTipValue) / Float(100)
            self.dasherTip = Money(cents: Int64((Float(viewModel.model.totalBeforeTipMoney.money.cents) * percentage).rounded(.up)))
        }
        totalFee = viewModel.model.totalBeforeTipMoney.money + dasherTip
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
            self.generateData()
            completion(nil)
        })
    }
}
