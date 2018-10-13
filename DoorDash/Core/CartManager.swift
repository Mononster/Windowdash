//
//  CartManager.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-09.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

final class CartManager {

    private let service: CartAPIService

    private var currentCart: Cart?

    var currentStoreID: Int64?
    var currentCartID: Int64?

    init() {
        service = CartAPIService()
    }

    func fetchCurrentCart(completion: @escaping (CartViewModel?, String?) -> ()) {
        guard let currentCartID = currentCartID else {
            completion(nil, "No cart ID provided")
            return
        }
        let request = FetchCartRequestModel(cartID: String(currentCartID))
        service.fetchCart(request: request) { (cart, error) in
            if let error = error as? CartAPIServiceError {
                completion(nil, error.errorMessage)
                return
            }
            guard let cart = cart else {
                completion(nil, "WTF NO CART?")
                return
            }

            self.currentCart = cart
            self.currentStoreID = cart.storeOrderCarts.first?.store.id
            completion(CartViewModel(model: cart), nil)
        }
    }

    func fetchOrCreateCurrentCartID(completion: @escaping (String?) -> ()) {
        service.getCurrentCartID { (id, error) in
            if let error = error as? CartAPIServiceError {
                if error.kind == .notFound {
                    // no cart, create a temp one for user.
                    self.createCart(completion: completion)
                    return
                }
                completion(error.errorMessage)
                return
            }
            guard let id = id else {
                completion("WTF NO ID?")
                return
            }
            self.currentCartID = id
            completion(nil)
        }
    }

    func createCart(completion: @escaping (String?) -> ()) {
        service.createCart { (id, error) in
            if let error = error as? CartAPIServiceError {
                completion(error.errorMessage)
                return
            }
            guard let id = id else {
                completion("WTF NO ID?")
                return
            }
            self.currentCartID = id
            completion(nil)
        }
    }
}
