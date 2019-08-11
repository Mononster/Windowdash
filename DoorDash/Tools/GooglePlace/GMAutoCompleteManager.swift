//
//  GMAutoCompleteManager.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import Moya

private let kMinRequestDelay: Double = 0
private let kMinQueryLength = 0

final class GMAutoCompleteManager {
    static let shared = GMAutoCompleteManager()

    var minRequestDelay = kMinRequestDelay
    var minQueryLength = kMinQueryLength

    private var performBlock: PerformAfterClosure?
    private var cache = NSCache<AnyObject, AnyObject>()
    private let service = GooglePlaceAPIService()
    private var lastSearch: Cancellable?
    var completionHandler: ((_ places: [GMPrediction]?) -> ())?

    func decode(_ searchTerm: String, completion: @escaping (_ places: [GMPrediction]?) -> ()) {
        completionHandler = completion
        if searchTerm.count >= minQueryLength {
            //cancel()
            if let cached = cachedResult(searchTerm) {
                print("Completed here")
                completeRequest(cached)
            } else {
                performBlock = performAfter(minRequestDelay, closure: { [weak self] () -> Void in
                    self?.startGeocodeSearch(searchTerm)
                })
            }
        } else {
            completeRequest(nil)
        }
    }

    func cancel() {
        cancelPerformAfter(performBlock)
        lastSearch?.cancel()
    }

    private func completeRequest(_ places: [GMPrediction]?) {
        completionHandler?(places)
    }

    private func startGeocodeSearch(_ searchTerm: String) {
        let search = service.fetchPredictions(input: searchTerm) { (predictions) in
            self.didDecode(searchTerm, predictions: predictions)
        }
        lastSearch = search
    }

    private func didFailDecode(_ searchTerm: String, error: Error) {
        log.error("Error: when trying to search \(searchTerm) : \(error)")
    }

    private func didDecode(_ searchTerm: String, predictions: [GMPrediction]?) {
        cacheResult(searchTerm, predictions: predictions)
        completeRequest(predictions)
    }

    private func cacheResult(_ searchTerm: String, predictions: [GMPrediction]?) {
        let cachePlace = predictions == nil ? [GMPrediction]() : predictions
        cache.setObject(cachePlace as AnyObject , forKey: searchTerm as AnyObject)
    }

    private func cachedResult(_ searchTerm: String) -> [GMPrediction]? {
        if let cached = cache.object(forKey: searchTerm as AnyObject) as? [GMPrediction] {
            return cached.count > 0 ? cached : nil
        }
        return nil
    }
}
