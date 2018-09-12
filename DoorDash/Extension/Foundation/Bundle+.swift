//
//  Bundle+.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-03.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation

protocol BundleType {
    var identifier: String { get }
    func path(forResource name: String?, ofType ext: String?) -> String?
    func url(forResource name: String?, withExtension ext: String?) -> URL?
    func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
    var infoDictionary: [String : Any]? { get }
}

enum UWLifeBundleIdentifier: String {
    case internalApp = "com.UWLife.internal"
    case releaseApp = "com.UWLife"
}

extension BundleType {
    var identifier: String {
        return self.infoDictionary?["CFBundleIdentifier"] as? String ?? "Unknown"
    }

    var shortVersionString: String {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var version: String {
        return self.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }

    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    var buildNumberInt: Int {
        return Int(Bundle.main.buildNumber ?? "-1") ?? -1
    }

    var fullVersion: String {
        let versionNumber = Bundle.main.shortVersionString
        let buildNumber = Bundle.main.buildNumber ?? ""
        return "\(versionNumber) (\(buildNumber))"
    }
}

extension Bundle : BundleType {}

