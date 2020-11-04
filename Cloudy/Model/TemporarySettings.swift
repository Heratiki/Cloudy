// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation

@objc class TemporarySettings: NSObject {

    @objc let absoluteTouchMode: Bool                  = false
    @objc let btMouseSupport:    Bool                  = false
    @objc let onscreenControls:  OnScreenControlsLevel = .full
}
