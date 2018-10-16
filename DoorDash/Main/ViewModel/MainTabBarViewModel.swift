//
//  MainTabBarViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-10.
//  Copyright © 2018 Monster. All rights reserved.
//

final class MainTabBarViewModel {

    var cartViewModel: CartViewModel?

    // TODO: Maybe considering add current cart ID to user default?
    // But how can we maintain single source of truth then?
    func fetchCurrentCart(completion: @escaping (String?) -> ()) {
        ApplicationDependency.manager.cartManager.fetchOrCreateCurrentCartID { errorMsg in
            if let error = errorMsg {
                completion(error)
                return
            }

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
                completion(nil)
            })
        }
    }

    func loadSavedCart() -> CartThumbnail? {
        return ApplicationDependency.manager.cartManager.getCartInfoFromUserDefaults()
    }
}
