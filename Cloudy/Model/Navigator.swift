// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import GameController

/// Model class to map navigation based on url
class Navigator {

    /// Some global constants
    struct Config {
        static let stadiaWarning                  = "https://stadia.google.com/warning/"
        static let stadiaWarningRedirectReason9   = "redirect_reasons=9"
        static let stadiaWarningRedirectReason10  = "redirect_reasons=10"
        static let googleAccountsWarning          = "deniedsigninrejected"
        static let signInString                   = "signin"

        /// Mapping from a alias to a full url
        static let aliasMapping: [String: String] = [
            "stadia": Url.googleStadia.absoluteString,
            "gfn": Url.geforceNow.absoluteString,
        ]

        struct Url {
            static let googleStadia   = URL(string: "https://stadia.google.com")!
            static let googleAccounts = URL(string: "https://accounts.google.com")!
            static let geforceNow     = URL(string: "https://play.geforcenow.com")!
            static let boosteroid     = URL(string: "https://cloud.boosteroid.com")!
            static let nvidiaRoot     = URL(string: "https://www.nvidia.com")!
            static let patreon        = URL(string: "https://www.patreon.com/cloudyApp")!
            static let paypal         = URL(string: "https://paypal.me/pools/c/8tPw2veZIm")!
        }

        struct UserAgent {
            static let chromeDesktop = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36"
            static let iPhone        = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15"
        }
    }

    /// The navigation that shall be executed
    struct Navigation {
        let userAgent:    String?
        let forwardToUrl: URL?
        let bridgeType:   CloudyController.JsonType
    }

    /// The manual fixed user agent override
    var manualUserAgent:    String? {
        UserDefaults.standard.manualUserAgent
    }

    /// Wrapper around user defaults saved user agent enabled / disabled flag
    var useManualUserAgent: Bool {
        UserDefaults.standard.useManualUserAgent
    }

    /// Map navigation address
    func getNavigation(for address: String?) -> Navigation {
        // early exit
        guard let requestedUrl = address else {
            return Navigation(userAgent: manualUserAgent, forwardToUrl: nil, bridgeType: .regular)
        }
        // map alias
        let navigationUrl = Config.aliasMapping[requestedUrl] ?? requestedUrl
        // no automatic navigation
        if useManualUserAgent {
            return Navigation(userAgent: manualUserAgent, forwardToUrl: nil, bridgeType: .regular)
        }
        // error happened with stadia, navigate to it directly
        if navigationUrl.starts(with: Config.stadiaWarning) &&
           (navigationUrl.reversed().starts(with: Config.stadiaWarningRedirectReason9.reversed()) ||
            navigationUrl.reversed().starts(with: Config.stadiaWarningRedirectReason10.reversed())) {
            return Navigation(userAgent: Config.UserAgent.chromeDesktop, forwardToUrl: Config.Url.googleStadia, bridgeType: .regular)
        }
        // google account error occurred
        if navigationUrl.starts(with: Config.Url.googleAccounts.absoluteString) &&
           navigationUrl.contains(Config.googleAccountsWarning) {
            return Navigation(userAgent: nil, forwardToUrl: Config.Url.googleAccounts, bridgeType: .regular)
        }
        // regular google stadia
        if navigationUrl.isEqualTo(other: Config.Url.googleStadia.absoluteString) {
            return Navigation(userAgent: Config.UserAgent.chromeDesktop, forwardToUrl: nil, bridgeType: .regular)
        }
        // regular geforce now
        if navigationUrl.starts(with: Config.Url.geforceNow.absoluteString) ||
           navigationUrl.starts(with: Config.Url.nvidiaRoot.absoluteString) {
            return Navigation(userAgent: Config.UserAgent.chromeDesktop, forwardToUrl: nil, bridgeType: .geforceNow)
        }
        // boosteroid
        if navigationUrl.starts(with: Config.Url.boosteroid.absoluteString) {
            return Navigation(userAgent: Config.UserAgent.chromeDesktop, forwardToUrl: nil, bridgeType: .regular)
        }
        // some problem with signing
        if navigationUrl.contains(Config.signInString) {
            return Navigation(userAgent: nil, forwardToUrl: nil, bridgeType: .regular)
        }
        return Navigation(userAgent: manualUserAgent, forwardToUrl: nil, bridgeType: .regular)
    }

    /// Handle popup
    func shouldOpenPopup(for url: String?) -> Bool {
        // early exit
        guard let url = url else {
            return false
        }
        if url.starts(with: Config.Url.boosteroid.absoluteString) {
            return false
        }
        return true
    }

}
