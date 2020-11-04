// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import GameController

/// Convenience extension
extension GCControllerButtonInput {

    /// Convenience creator
    var controller: CloudyController.Button {
        CloudyController.Button(pressed: isPressed, touched: isTouched, value: value)
    }
}

/// Convenience extension
extension GCExtendedGamepad {

    /// Enum for the specific json export
    public enum JsonType {
        case regular
        case geforceNow
    }

    /// Hacked pulsing
    /// TODO find a proper solution
    private static var pulse: Bool = false

    /// Constant static id
    public static var  id:    String {
        "Xbox Wireless Controller (STANDARD GAMEPAD Vendor: 045e Product: 02fd)"
    }

    /// Convert to json
    public func toJson(for type: JsonType) -> String? {
        guard let buttonOptions = buttonOptions,
              let buttonHome = buttonHome,
              let leftThumbstickButton = leftThumbstickButton,
              let rightThumbstickButton = rightThumbstickButton else {
            return nil
        }
        GCExtendedGamepad.pulse = !GCExtendedGamepad.pulse
        return CloudyController(
                axes: [
                    leftThumbstick.xAxis.value,
                    -1.0 * leftThumbstick.yAxis.value,
                    rightThumbstick.xAxis.value,
                    -1.0 * rightThumbstick.yAxis.value
                ],
                buttons: [
                    /*  0 */ buttonA.controller,
                    /*  1 */ buttonB.controller,
                    /*  2 */ buttonX.controller,
                    /*  3 */ buttonY.controller,
                    /*  4 */ leftShoulder.controller,
                    /*  5 */ rightShoulder.controller,
                    /*  6 */ type == .regular ? leftTrigger.controller : CloudyController.Button(pressed: leftTrigger.isPressed, touched: leftTrigger.isTouched, value: max(leftTrigger.value - 0.002, 0) + (GCExtendedGamepad.pulse ? 0.002 : 0)),
                    /*  7 */ rightTrigger.controller,
                    /*  8 */ buttonOptions.controller,
                    /*  9 */ buttonMenu.controller,
                    /* 10 */ leftThumbstickButton.controller,
                    /* 11 */ rightThumbstickButton.controller,
                    /* 12 */ dpad.up.controller,
                    /* 13 */ dpad.down.controller,
                    /* 14 */ dpad.left.controller,
                    /* 15 */ dpad.right.controller,
                    /* 16 */ buttonHome.controller,
                ])
                .jsonString
    }
}
