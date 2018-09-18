//
//  OnboardingViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-16.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

private let onboardingTitles: [String] = [
    "ALL YOUR FAVOURITES",
    "FREE DELIVERY OFFERS",
    "UNMATCHED RELIABILITY",
    "FIVE STAR DASHERS",
    "HERE FOR YOU"
]
private let onboardingDescriptions: [String] = [
    "Order from the best local restaurants with easy, on-demand delivery.",
    "DoorDash regularly offers free delivery for new customers via Apple Pay.",
    "Experience peace of mind while tracking your order in real time.",
    "Enjoy deliveries from a friendly vetted fleet.",
    "Something come up? Talk to a real person. We're here to help"
]

final class OnboardingViewModel {

    var onboardingItems: [OnboardingItem] = []

    init() {
        configItems()
    }

    private func configItems() {
        let onboardingImages = ApplicationDependency.manager.theme.imageAssets.onboardingImages
        for (i, image) in onboardingImages.enumerated() {
            onboardingItems.append(OnboardingItem(
                image: image,
                title: onboardingTitles[i],
                description: onboardingDescriptions[i])
            )
        }
    }
}
