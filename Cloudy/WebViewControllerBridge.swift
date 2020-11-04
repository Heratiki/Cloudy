// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import WebKit
import GameController


/// Main module that connects the web views controller scripts to the native controller handling
@objc class WebViewControllerBridge: NSObject, WKScriptMessageHandlerWithReply {

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

    /// Handle user content controller with proper native controller data reply
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage,
                               replyHandler: @escaping (Any?, String?) -> Void) {
        //////////////////// VIRTUAL CONTROLLER
        if let virtualController = WebViewControllerBridge.virtualController {
            replyHandler(virtualController.jsonString, nil)
            return
        }

        //////////////////// PHYSICAL CONTROLLER
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
