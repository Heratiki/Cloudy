// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation

/// String relevant extension
extension String {

    /// Insert https:// if required
    func fixedProtocol() -> String {
        if starts(with: "https://") || starts(with: "http://") {
            return self
        }
        return "https://" + self
    }

    /// Compare against other string (with trailing slash)
    func isEqualTo(other: String) -> Bool {
        self == other ||
        self + "/" == other ||
        self == other + "/"
    }
}