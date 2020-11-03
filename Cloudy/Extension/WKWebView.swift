// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import WebKit
import GameController

/// Types of navigation
enum Navigation {
    case forward
    case backward
    case reload
}

/// Navigation execution hidden behind this protocol
protocol WebController {
    func executeNavigation(action: Navigation)
    func navigateTo(address: String)
    func clearCache()
}

/// The script to be injected into the webview
/// It's overwriting the navigator.getGamepads function
/// to make the connection with the native GCController solid
private let script: String = """
                             var emulatedGamepad = {
                                 id: "\(GCExtendedGamepad.id)",
                                 index: 0,
                                 connected: true,
                                 timestamp: 0.0,
                                 mapping: "standard",
                                 axes: [0.0, 0.0, 0.0, 0.0],
                                 buttons: new Array(17).fill().map((m) => {
                                      return { pressed: false, touched: false, value: 0 }
                                 })
                             }

                             navigator.getGamepads = function() {
                                 window.webkit.messageHandlers.controller.postMessage({}).then((controllerData) => {
                                     if (controllerData === null || controllerData === undefined) return;
                                     try {
                                         var data = JSON.parse(controllerData);
                                         for(let i = 0; i < data.axes.length; i++) {
                                             emulatedGamepad.axes[i] = data.axes[i];
                                         }
                                         for(let i = 0; i < data.buttons.length; i++) {
                                             emulatedGamepad.buttons[i].pressed = data.buttons[i].pressed;
                                             emulatedGamepad.buttons[i].touched = data.buttons[i].touched;
                                             emulatedGamepad.buttons[i].value   = data.buttons[i].value;
                                         }
                                         emulatedGamepad.timestamp = performance.now();
                                         // console.log(emulatedGamepad);
                                     } catch(e) { 
                                         console.error("something went wrong: " + e);  
                                     }
                                 });
                                 return [emulatedGamepad, null, null, null];
                             };
                             """

extension WKWebView: WebController {

    /// Execute given navigation
    func executeNavigation(action: Navigation) {
        switch action {
            case .forward:
                goForward()
            case .backward:
                goBack()
            case .reload:
                guard let url = url else { return }
                navigateTo(url: url)
        }
    }

    /// Clear cache
    func clearCache() {
        // clean cookies
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // clean cache
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }

    /// Navigate to a given string
    func navigateTo(address: String) {
        /// build url
        guard let url = URL(string: address.fixedProtocol()) else {
            print("Error creating Url from '\(address)'")
            return
        }
        // load
        navigateTo(url: url)
    }

    /// Navigate to url
    func navigateTo(url: URL) {
        load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }

    /// Inject inject the js controller script
    func injectControllerScript() {
        evaluateJavaScript(script, completionHandler: nil)
    }
}
