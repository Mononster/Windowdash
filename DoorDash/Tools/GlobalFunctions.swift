//
//  GlobalFunctions.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-19.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit

typealias PerformAfterClosure = (_ cancel: Bool) -> ()

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func performAfter(_ delayTime: Double, closure: @escaping ()->()) -> PerformAfterClosure? {
    var closure: (()->())? = closure
    var performClosure: PerformAfterClosure?
    let delayedClosure: PerformAfterClosure = { cancel in
        if let uclosure = closure {
            if !cancel {
                DispatchQueue.main.async(execute: uclosure)
            }
        }
        closure = nil
        performClosure = nil
    }
    performClosure = delayedClosure
    delay(delayTime, closure: {
        if let delayedClosure = performClosure {
            delayedClosure(false)
        }
    })
    return performClosure
}

func cancelPerformAfter(_ closure: PerformAfterClosure?) {
    if let uclosure = closure {
        uclosure(true)
    }
}

class HelperManager {

    static func uniqueID() -> String {
        return UUID().uuidString.lowercased()
    }

    static func textHeight(_ text: String?, width: CGFloat, font: UIFont) -> CGFloat {
        guard let text = text else {
            return 0
        }
        if text.isEmpty { return 0 }
        let constrainedSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        return ceil(bounds.height)
    }

    static func textWidth(_ text: String?, font: UIFont) -> CGFloat {
        guard let text = text else {
            return 0
        }
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = text.size(withAttributes: fontAttributes)
        return size.width
    }
}
