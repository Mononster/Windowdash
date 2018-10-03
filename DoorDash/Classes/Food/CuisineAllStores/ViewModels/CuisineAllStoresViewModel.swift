//
//  CuisineAllStoresViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-27.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class CuisineAllStoresViewModel {

    private let storeList: StoreListViewModel
    private let service: BrowseFoodAPIService

    let cuisineName: String
    var sectionData: [ListDiffable] = []

    init(service: BrowseFoodAPIService, cuisine: BrowseFoodCuisineCategory) {
        self.service = service
        storeList = StoreListViewModel(service: service, query: cuisine.name)
        cuisineName = cuisine.friendlyName
    }

    func loadMoreStores(completion: @escaping (Bool) -> ()) {
        self.storeList.loadMoreStores { (stores, shouldRefresh) in
            if !shouldRefresh {
                completion(false)
                return
            }
            self.sectionData.append(contentsOf: stores)
            completion(true)
        }
    }

    func fetchStores(completion: @escaping (String?) -> ()) {
        storeList.fetchFirstList { items, errorMsg in
            if let error = errorMsg {
                completion(error)
                return
            }
            self.sectionData.append(contentsOf: items)
            completion(nil)
        }
    }
}
