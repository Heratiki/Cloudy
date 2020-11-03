// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation

/// Convenience access to persisted user defaults
extension UserDefaults {

    /// Some keys for the user defaults
    private struct Config {
        static let lastVisitedUrlKey  = "lastVisitedUrlKey"
        static let manualUserAgent    = "manualUserAgent"
        static let useManualUserAgent = "useManualUserAgent"
        static let allowInlineMedia   = "allowInlineMedia"
    }

    /// Read / write the last visited url
    var lastVisitedUrl:     URL? {
        get {
            UserDefaults.standard.url(forKey: Config.lastVisitedUrlKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.lastVisitedUrlKey)
        }
    }

    /// Read / write the manually overwritten user agent
    var manualUserAgent:    String? {
        get {
            UserDefaults.standard.string(forKey: Config.manualUserAgent)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.manualUserAgent)
        }
    }

    /// Read / write the flag if the manual user agent should be used
    var useManualUserAgent: Bool {
        get {
            if UserDefaults.standard.object(forKey: Config.useManualUserAgent) == nil {
                return false
            }
            return UserDefaults.standard.bool(forKey: Config.useManualUserAgent)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.useManualUserAgent)
        }
    }

    /// Read / write allow inline media enabled flag
    var allowInlineMedia:   Bool {
        get {
            if UserDefaults.standard.object(forKey: Config.allowInlineMedia) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: Config.allowInlineMedia)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Config.allowInlineMedia)
        }
    }

}