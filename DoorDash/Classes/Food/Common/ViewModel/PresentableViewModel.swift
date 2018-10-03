//
//  PresentableViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-30.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

protocol PresentableViewModel {
    var sectionData: [ListDiffable] { get }
}
