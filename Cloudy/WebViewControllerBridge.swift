// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import WebKit
import GameController

@objc enum ControlsSource: Int {
    case none
    case onScreen
    case external
}

/// Protocol to handle incoming cloudy controller sources
@objc protocol ControllerDataReceiver {
    @objc func submit(controllerData: CloudyController, for type: ControlsSource)
}

/// Main module that connects the web views controller scripts to the native controller handling
class WebViewControllerBridge: NSObject, WKScriptMessageHandlerWithReply, ControllerDataReceiver {

    /// Alias for the reply type back to the webWiew
    typealias ReplyHandlerType = (Any?, String?) -> Void

    private var controllerData:         [ControlsSource: CloudyController] = [:]

    /// Remember last controller snapshot
    private var lastControllerSnapshot: GCExtendedGamepad?                 = nil

    /// current export type
    var exportType:     GCExtendedGamepad.JsonType = .regular

    /// the controls source to use
    var controlsSource: ControlsSource             = .none

    /// Handle user content controller with proper native controller data reply
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage,
                               replyHandler: @escaping ReplyHandlerType) {
        // only execute if the correct message was received
        guard message.name == WKWebView.messageHandlerName else {
            Log.e("Unknown message received: \(message)")
            return
        }
        // return value depending on configuration
        switch (controlsSource) {
            case .none:
                break
            case .onScreen:
                handleTouchController(with: replyHandler)
            case .external:
                handleRegularController(with: replyHandler)
        }
    }

    /// Handle regular external controller
    private func handleRegularController(with replyHandler: @escaping ReplyHandlerType) {
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

    /// Handle touch controller
    @available(*, deprecated, message: "Implement that functionality properly, no forwarding to native controller if we are using touch with geforce now")
    private func handleTouchController(with replyHandler: @escaping ReplyHandlerType) {
        // Todo remove this hack
        guard exportType == .regular else {
            handleRegularController(with: replyHandler)
            return
        }
        if let controllerData = controllerData[.onScreen] {
            replyHandler(controllerData.jsonString, nil)
            return
        }
        replyHandler(nil, nil)
    }

    /// Receive the controller data
    func submit(controllerData: CloudyController, for type: ControlsSource) {
        self.controllerData[type] = controllerData
    }
}
