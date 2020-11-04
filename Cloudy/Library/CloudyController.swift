// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import GameController

/// Struct for generating a js readable json that contains the
/// proper values from the native controller
struct CloudyController: Encodable {

    /// Button of the controller
    public struct Button: Encodable {
        let pressed: Bool
        let touched: Bool
        let value:   Float
    }

    /// Axes and buttons are the only dynamic values
    let axes:    [Float]
    let buttons: [Button?]

    /// Some static ones for proper configuration
    private let connected: Bool   = true
    private let id:        String = GCExtendedGamepad.id
    private let index:     Int    = 0
    private let mapping:   String = "standard"
    private let timestamp: Float  = 0

    /// Conversion to json
    var jsonString: String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }

    static func button(pressed: Bool) -> CloudyController.Button {
        return CloudyController.Button(pressed: pressed, touched: pressed, value: pressed ? 1 : 0)
    }

    static func button(value: Float) -> CloudyController.Button {
        let closeToZero: (Float) -> Bool = { abs($0) < 0.0001 }
        return CloudyController.Button(pressed: closeToZero(value), touched: closeToZero(value), value: value)
    }

    static func createFrom(controllerNumber: CShort, activeGamepadMask: CShort,
                           buttonFlags: CShort, leftTrigger: CUnsignedChar, rightTrigger: CUnsignedChar,
                           leftStickX: CShort, leftStickY: CShort, rightStickX: CShort, rightStickY: CShort) -> CloudyController {
        let buttonSet = ButtonOptionSet(rawValue: Int(buttonFlags))
        return CloudyController(
                axes: [
                    Float(leftStickX) / Float(CShort.max),
                    -1.0 * Float(leftStickY) / Float(CShort.max),
                    Float(rightStickX) / Float(CShort.max),
                    -1.0 * Float(rightStickY) / Float(CShort.max),
                ],
                buttons: [
                    /*  0 */ button(pressed: buttonSet.contains(.A_FLAG)),
                    /*  1 */ button(pressed: buttonSet.contains(.B_FLAG)),
                    /*  2 */ button(pressed: buttonSet.contains(.X_FLAG)),
                    /*  3 */ button(pressed: buttonSet.contains(.Y_FLAG)),
                    /*  4 */ button(pressed: buttonSet.contains(.LB_FLAG)), // leftShoulder.controller,
                    /*  5 */ button(pressed: buttonSet.contains(.RB_FLAG)), // rightShoulder.controller,
                    /*  6 */ button(value: Float(leftTrigger) / Float(CUnsignedChar.max)), // leftTrigger.controller,
                    /*  7 */ button(value: Float(rightTrigger) / Float(CUnsignedChar.max)), // rightTrigger.controller,
                    /*  8 */ button(pressed: buttonSet.contains(.BACK_FLAG)), // buttonOptions.controller,
                    /*  9 */ button(pressed: buttonSet.contains(.PLAY_FLAG)), // buttonMenu.controller,
                    /* 10 */ button(pressed: buttonSet.contains(.LS_CLK_FLAG)), // leftThumbstickButton.controller,
                    /* 11 */ button(pressed: buttonSet.contains(.RS_CLK_FLAG)), // rightThumbstickButton.controller,
                    /* 12 */ button(pressed: buttonSet.contains(.UP_FLAG)), // dpad.up.controller,
                    /* 13 */ button(pressed: buttonSet.contains(.DOWN_FLAG)), // dpad.down.controller,
                    /* 14 */ button(pressed: buttonSet.contains(.LEFT_FLAG)), // dpad.left.controller,
                    /* 15 */ button(pressed: buttonSet.contains(.RIGHT_FLAG)), // dpad.right.controller,
                    /* 16 */ button(pressed: false), // buttonHome.controller,
                ])
    }

}

