//
//  BrowseDrinkViewController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-25.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

private let titles: [String] = [
    "Popular items", "Appetizers", "Small Plates + California", "Soups", "Salads", "Power Bowls", "Original Hand-Tossed Pizzas", "Crispy Thin Crust Pizzas", "Gluten-Free Pizzas", "Pastas", "Main Plates", "CPKids", "Desserts", "Additions and Extras", "Beverages", "Sides and Add Ons"
]

final class BrowseDrinkViewController: BaseViewController {

    private let segmentNavigateView: SegmentNavigateView
    
    override init() {
        segmentNavigateView = SegmentNavigateView(
            frame: CGRect(
                x: 0, y: UIDevice.current.statusBarHeight,
                width: UIScreen.main.bounds.width, height: 45)
        )
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        segmentNavigateView.setTitles(titles: titles)
    }
}

extension BrowseDrinkViewController {

    private func setupUI() {
        self.view.addSubview(segmentNavigateView)
    }
}
