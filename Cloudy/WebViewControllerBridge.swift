// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import WebKit
import GameController
import CloudyLibrary

/// Main module that connects the web views controller scripts to the native controller handling
class WebViewControllerBridge: NSObject, WKScriptMessageHandlerWithReply {

    /// Remember last controller snapshot
    var lastControllerSnapshot: GCExtendedGamepad?         = nil

    /// current export type
    var exportType:             GCExtendedGamepad.JsonType = .regular

    /// Handle user content controller with proper native controller data reply
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage,
                               replyHandler: @escaping (Any?, String?) -> Void) {
        // early exit
        guard let currentControllerState = GCController.controllers().first?.extendedGamepad else {
            replyHandler(nil, nil)
            return
        }
        // nothing changed, skip
        if let lastControllerState = lastControllerSnapshot,
           lastControllerState =~ currentControllerState {
            replyHandler(nil, nil)
            return
        }
        // update and save
        lastControllerSnapshot = currentControllerState.capture()
        replyHandler(currentControllerState.toJson(for: exportType), nil)
    }
}
