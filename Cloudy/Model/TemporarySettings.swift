// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation

@available(*, deprecated, message: "Remove this nasty shortcut")
@objc class TemporarySettings: NSObject {

    @objc let absoluteTouchMode: Bool = false
    @objc let btMouseSupport:    Bool = false
}
