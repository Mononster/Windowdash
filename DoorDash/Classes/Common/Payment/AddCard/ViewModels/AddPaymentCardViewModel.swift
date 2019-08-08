//
//  AddPaymentCardViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-28.
//  Copyright © 2018 Monster. All rights reserved.
//

import Stripe

final class AddPaymentCardViewModel {

    func submitCardInfoToServer(cardNumber: String?,
                                expirationYear: UInt,
                                expirationMonth: UInt,
                                cvc: String?,
                                postalCode: String?,
                                completion: @escaping (String?) -> ()) {

        let cardParams = STPCardParams()
        cardParams.number = cardNumber
        cardParams.expMonth = expirationMonth
        cardParams.expYear = expirationYear
        cardParams.address.postalCode = postalCode
        cardParams.cvc = cvc
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                completion(error?.localizedDescription ?? "")
                return
            }
            PaymentAPIService().addPaymentCard(token: token.tokenId, completion: { (paymentMethod, error) in
                if let error = error as? APIServiceError {
                    log.error(error)
                    completion(error.errorMessage)
                    return
                }
                guard paymentMethod != nil else {
                    completion("No payment method found.")
                    return
                }
                completion(nil)
            })
        }
    }
}
