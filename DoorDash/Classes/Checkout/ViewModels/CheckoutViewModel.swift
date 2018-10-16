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
        guard let viewModel = cartViewModel else {
            return
        }
        calcTipAmount(viewModel: viewModel)
        self.sectionData.removeAll()
    }

    func calcTipAmount(viewModel: CartViewModel) {
        guard let tipSuggestion = viewModel.model.tipSuggestions else {
            return
        }
        dasherTipDefaultIndex = tipSuggestion.defaultIndex
        for value in tipSuggestion.tipValues {
            if tipSuggestion.type == .amount {
                dasherTipSelections.append(String(value))
            } else {
                dasherTipSelections.append(String(value) + "%")
            }
        }
        let defaultTipValue = tipSuggestion.tipValues[safe: tipSuggestion.defaultIndex] ?? 0
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
