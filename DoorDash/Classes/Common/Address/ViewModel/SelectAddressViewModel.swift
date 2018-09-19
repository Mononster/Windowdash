//
//  SelectAddressViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit

final class SelectAddressViewModel {

    var userAddress: String = ""
    var geoLocation: GMPrediction?
    var queries: QueriedAddresses

    var contentHeight: CGFloat {
        return 60 + CGFloat(queries.predictions.count) * AddressTextLabelSectionController.cellHeight
    }

    var data: [Any] = []

    init() {
        data.append(userAddress)
        queries = QueriedAddresses(predictions: [])
    }

    func confirmSelection(prediction: GMPrediction) {
        self.userAddress = prediction.address
        self.geoLocation = prediction
        self.queries = QueriedAddresses(predictions: [])
        if self.data.count > 1 {
            self.data.removeLast()
        }
    }

    func searchAddress(query: String, completion: @escaping () -> ()) {
        GMAutoCompleteManager.shared.decode(query) { (predictions) in
            guard let predictions = predictions, predictions.count > 0 else {
                return
            }
            self.queries = QueriedAddresses(predictions: predictions.prefix(4).uniqueElements)
            if self.data.count == 1 {
                self.data.append(self.queries)
            } else {
                self.data[1] = self.queries
            }
            completion()
        }
    }
}
