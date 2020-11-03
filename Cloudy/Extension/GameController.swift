// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import GameController
import CloudyLibrary

/// Infix operator declaration
infix operator =~: ComparisonPrecedence

/// Convenience extension
extension GCControllerButtonInput {

    /// Compare for similarity
    static func =~(lhs: GCControllerButtonInput, rhs: GCControllerButtonInput) -> Bool {
        lhs.isPressed == rhs.isPressed &&
        lhs.isTouched == rhs.isTouched &&
        lhs.value =~ rhs.value
    }
}

/// Convenience extension
extension Float {

    /// Check for similarity
    static func =~(lhs: Float, rhs: Float) -> Bool {
        abs(lhs - rhs) < 0.001
    }
}

/// Convenience extension
extension GCExtendedGamepad {

    /// Check all values for similarity
    static func =~(lhs: GCExtendedGamepad, rhs: GCExtendedGamepad) -> Bool {
        guard let lhsButtonOptions = lhs.buttonOptions,
              let lhsButtonHome = lhs.buttonHome,
              let lhsLeftThumbstickButton = lhs.leftThumbstickButton,
              let lhsRightThumbstickButton = lhs.rightThumbstickButton,
              let rhsButtonOptions = rhs.buttonOptions,
              let rhsButtonHome = rhs.buttonHome,
              let rhsLeftThumbstickButton = rhs.leftThumbstickButton,
              let rhsRightThumbstickButton = rhs.rightThumbstickButton,
              lhs.leftThumbstick.xAxis.value =~ rhs.leftThumbstick.xAxis.value,
              lhs.leftThumbstick.yAxis.value =~ rhs.leftThumbstick.yAxis.value,
              lhs.rightThumbstick.xAxis.value =~ rhs.rightThumbstick.xAxis.value,
              lhs.rightThumbstick.yAxis.value =~ rhs.rightThumbstick.yAxis.value,
              lhs.buttonA =~ rhs.buttonA,
              lhs.buttonB =~ rhs.buttonB,
              lhs.buttonX =~ rhs.buttonX,
              lhs.buttonY =~ rhs.buttonY,
              lhs.leftShoulder =~ rhs.leftShoulder,
              lhs.rightShoulder =~ rhs.rightShoulder,
              lhs.leftTrigger =~ rhs.leftTrigger,
              lhs.rightTrigger =~ rhs.rightTrigger,
              lhsButtonOptions =~ rhsButtonOptions,
              lhs.buttonMenu =~ rhs.buttonMenu,
              lhsLeftThumbstickButton =~ rhsLeftThumbstickButton,
              lhsRightThumbstickButton =~ rhsRightThumbstickButton,
              lhs.dpad.up =~ rhs.dpad.up,
              lhs.dpad.down =~ rhs.dpad.down,
              lhs.dpad.left =~ rhs.dpad.left,
              lhs.dpad.right =~ rhs.dpad.right,
              lhsButtonHome =~ rhsButtonHome else {
            return false
        }
        return true
    }
}