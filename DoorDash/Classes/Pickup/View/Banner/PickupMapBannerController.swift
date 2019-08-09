//
//  PickupMapBannerController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/9/19.
//  Copyright © 2019 Monster. All rights reserved.
//

final class PickupMapBannerController {

    let primaryBanner: PickupMapBannerView
    let secondaryBanner: PickupMapBannerView

    init(primaryBanner: PickupMapBannerView, secondaryBanner: PickupMapBannerView) {
        self.primaryBanner = primaryBanner
        self.secondaryBanner = secondaryBanner
    }

    func pickBannerToShow() -> PickupMapBannerView {
        if primaryBanner.viewState == .hidden {
            return primaryBanner
        }
        return secondaryBanner
    }
}
