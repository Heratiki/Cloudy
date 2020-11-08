// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import WebKit
import GameController


/// Main module that connects the web views controller scripts to the native controller handling
@objc class WebViewControllerBridge: NSObject, WKScriptMessageHandlerWithReply {

    enum ControlsSource {
        case none
        case onScreen
        case external
    }

    typealias ReplyHandlerType = (Any?, String?) -> Void

    @objc public static func submit(controllerNumber: CShort, activeGamepadMask: CShort,
                                    buttonFlags: CShort, leftTrigger: CUnsignedChar, rightTrigger: CUnsignedChar,
                                    leftStickX: CShort, leftStickY: CShort, rightStickX: CShort, rightStickY: CShort) {
        virtualController = CloudyController.createFrom(controllerNumber: controllerNumber,
                                                        activeGamepadMask: activeGamepadMask,
                                                        buttonFlags: buttonFlags,
                                                        leftTrigger: leftTrigger,
                                                        rightTrigger: rightTrigger,
                                                        leftStickX: leftStickX,
                                                        leftStickY: leftStickY,
                                                        rightStickX: rightStickX,
                                                        rightStickY: rightStickY)
    }

    /// TODO REMOVE THIS HACK
    static var virtualController: CloudyController? = nil

    /// Remember last controller snapshot
    var lastControllerSnapshot: GCExtendedGamepad?         = nil

    /// current export type
    var exportType:             GCExtendedGamepad.JsonType = .regular

    /// the controls source to use
    var controlsSource:         ControlsSource             = .none

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
    private func handleTouchController(with replyHandler: @escaping ReplyHandlerType) {
        if let virtualController = WebViewControllerBridge.virtualController {
            replyHandler(virtualController.jsonString, nil)
            return
        }
        replyHandler(nil, nil)
    }
}
