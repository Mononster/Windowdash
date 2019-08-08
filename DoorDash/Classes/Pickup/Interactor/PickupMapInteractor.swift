//
//  PickupMapInteractor.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/8/19.
//  Copyright © 2019 Monster. All rights reserved.
//

final class PickupMapInteractor {

    private let presenter: PickupMapPresenter
    private let apiService: BrowseFoodAPIService

    init(presenter: PickupMapPresenter, apiService: BrowseFoodAPIService) {
        self.presenter = presenter
        self.apiService = apiService
    }
}

extension PickupMapInteractor {

    func loadData() {
        
    }
}
