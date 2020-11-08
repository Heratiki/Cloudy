// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation

/// Button option mask used by moonlight
struct ButtonOptionSet: OptionSet {
    let rawValue: Int

    static let A_FLAG       = ButtonOptionSet(rawValue: 0x1000)
    static let B_FLAG       = ButtonOptionSet(rawValue: 0x2000)
    static let X_FLAG       = ButtonOptionSet(rawValue: 0x4000)
    static let Y_FLAG       = ButtonOptionSet(rawValue: 0x8000)
    static let UP_FLAG      = ButtonOptionSet(rawValue: 0x0001)
    static let DOWN_FLAG    = ButtonOptionSet(rawValue: 0x0002)
    static let LEFT_FLAG    = ButtonOptionSet(rawValue: 0x0004)
    static let RIGHT_FLAG   = ButtonOptionSet(rawValue: 0x0008)
    static let LB_FLAG      = ButtonOptionSet(rawValue: 0x0100)
    static let RB_FLAG      = ButtonOptionSet(rawValue: 0x0200)
    static let PLAY_FLAG    = ButtonOptionSet(rawValue: 0x0010)
    static let BACK_FLAG    = ButtonOptionSet(rawValue: 0x0020)
    static let LS_CLK_FLAG  = ButtonOptionSet(rawValue: 0x0040)
    static let RS_CLK_FLAG  = ButtonOptionSet(rawValue: 0x0080)
    static let SPECIAL_FLAG = ButtonOptionSet(rawValue: 0x0400)
}
