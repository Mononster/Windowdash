//
//  CuratedCategoryAllStoresViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 9/28/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class CuratedCategoryAllStoresViewModel {

    private let storeList: StoreListViewModel
    private let service: BrowseFoodAPIService

    var sectionData: [ListDiffable] = []
    let categoryName: String?
    let categoryDescription: String?

    init(service: BrowseFoodAPIService, id: String, name: String, description: String?) {
        self.service = service
        self.categoryName = name
        self.categoryDescription = description
        storeList = StoreListViewModel(service: service, serverFetchLimit: 20, curatedCateogryID: id)
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
            if let description = self.categoryDescription {
                self.sectionData.append(CuratedCategoryHeaderModel(title: description))
            }
            self.sectionData.append(contentsOf: items)
            completion(nil)
        }
    }
}

