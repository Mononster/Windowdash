//
//  Foundation+.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import SwiftyJSON
import ImageIO

extension Int {
    public static var formatTime: (_ sec: Int) -> String {
        return { sec in
            let min = sec / 60
            var prefixString: String
            if min > 59 {
                let minute = min % 60
                let hr = min / 60
                prefixString = String(format: "%02d:%02d", hr, minute)
            } else {
                prefixString = String(format: "%02d", min)
            }
            let sec = sec % 60
            let secString = String(format: "%02d", sec)
            return "\(prefixString):\(secString)"
        }
    }
}


extension String {
    public func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }


    public var nsrange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }

    public var digitOnly: String? {
        do {
            let regex = try NSRegularExpression(pattern: "\\D", options: .caseInsensitive)
            return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: "")
        } catch {
            #if DEBUG
                print("\(error)")
            #endif
            return nil
        }
    }

    public var containsWhitespace: Bool {
        guard rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) != nil else {
            return false
        }
        return true
    }

    // Return flag emoji representation of country code if available
    public var formatAsFlagMaybe: String {
        let base: UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            if let unicodeScalar: UnicodeScalar = UnicodeScalar(base + v.value) {
                s.unicodeScalars.append(UnicodeScalar(unicodeScalar))
            }
        }
        return s
    }
}

public enum AttributeTag: String {
    case bold = "b"
    case link = "link"
}

public struct StringAttributeTagStyle {
    public let fontStyle: [AttributeTag : UIFont]?
    public let colorStyle: [AttributeTag : UIColor]?
    public let backgroundStyle: [AttributeTag: UIColor]?
    public let regularFont: UIFont
    public let regularColor: UIColor
    public let regularBackgroundColor: UIColor

    public init(fontStyle: [AttributeTag : UIFont]? = nil,
                colorStyle: [AttributeTag : UIColor]? = nil,
                backgroundStyle: [AttributeTag: UIColor]? = nil,
                regularFont: UIFont,
                regularColor: UIColor,
                regularBackgroundColor: UIColor = .clear) {
        self.fontStyle = fontStyle
        self.colorStyle = colorStyle
        self.backgroundStyle = backgroundStyle
        self.regularFont = regularFont
        self.regularColor = regularColor
        self.regularBackgroundColor = regularBackgroundColor
    }
}

extension Notification.Name {
    public static let unAuthorized = Notification.Name(rawValue: "com.doordash.unauthorized")
}

extension FileManager {
    public func createUserDirectory(searchPath: SearchPathDirectory) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(searchPath, .userDomainMask, true)
        guard let rootDirectory = paths.first else {
            return nil
        }
        var isDirectory: ObjCBool = ObjCBool(false)
        if !fileExists(atPath: rootDirectory, isDirectory: &isDirectory) && isDirectory.boolValue {
            do {
                try createDirectory(atPath: rootDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                log.error("Can't create directory, returning")
                return nil
            }
        }
        return rootDirectory
    }
}

extension TimeInterval {
    public var formattedString: () -> String {
        return {
            let sec = Int(self)
            return Int.formatTime(sec)
        }
    }
}

extension JSON {
    public var isNull: Bool {
        guard null != nil else {
            return false
        }
        return true
    }
}

extension Set {
    public func setMap<U>(_ transform: (Element) throws -> U) rethrows -> Set<U> {
        return try Set<U>(lazy.map(transform))
    }
}

extension Bundle {
    public var currentAppVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
}

public protocol Optionalable {
    associatedtype WrappedType
    func unwrap() -> WrappedType
    func isPresent() -> Bool
}

extension Optional : Optionalable {
    public typealias WrappedType = Wrapped

    public func unwrap() -> Wrapped {
        return self!
    }

    public func isPresent() -> Bool {
        return self != nil
    }
}

extension DispatchQueue {

    private static var onceTracker: [String] = []

    //Executes a block of code, associated with a unique token, only once.  The code is thread safe and will only execute the code once even in the presence of multithreaded calls.
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { // 作用域结束后执行defer中的代码
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}
