//
//  CartManager.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-09.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

final class CartManager {

    private let cartStorageKey = "com.DoorDash.cartThumbnailStorageKey"
    private let service: CartAPIService
    private var currentCartViewModel: CartViewModel?

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

            self.currentCartViewModel = CartViewModel(model: cart)
            self.saveCartInfoToUserDefaults()
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

    func removeItemFromCart(id: Int64, completion: @escaping (String?) -> ()) {
        service.removeItemFromCart(id: id) { error in
            if let error = error as? CartAPIServiceError {
                completion(error.errorMessage)
                return
            }
            completion(nil)
        }
    }
}

extension CartManager {

    func saveCartInfoToUserDefaults() {
        guard let cart = currentCartViewModel else {
            return
        }
        let cartThumbnail = CartThumbnail(id: cart.model.id,
                                          isEmpty: cart.isEmptyCart,
                                          title: cart.storeNameAndQuantityDisplay)
        UserDefaults.standard.set(object: cartThumbnail, forKey: cartStorageKey)
        UserDefaults.standard.synchronize()
    }

    func getCartInfoFromUserDefaults() -> CartThumbnail? {
        guard let cart = UserDefaults.standard.object(type: CartThumbnail.self, with: cartStorageKey) else {
            return nil
        }
        if cart.isEmpty { return nil }
        self.currentCartID = cart.id
        return cart
    }

    func removeCartInfoFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: cartStorageKey)
        UserDefaults.standard.synchronize()
    }
}
