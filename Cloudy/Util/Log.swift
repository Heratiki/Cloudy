// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import os.log

/// Class for logging
public class Log: NSObject {

    /// Log at debug level
    @inline(__always) @objc
    public static func d(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        #if DEBUG
            log("D", OSLogType.debug, message, file, line)
        #endif
    }

    /// Log at info level
    @inline(__always) @objc
    public static func i(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        #if DEBUG
            log("I", OSLogType.info, message, file, line)
        #endif
    }

    /// Log at default log level
    @inline(__always) @objc
    public static func l(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        log("L", OSLogType.default, message, file, line)
    }

    /// Log at warning level
    @inline(__always) @objc
    public static func f(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        log("F", OSLogType.fault, message, file, line)
    }

    /// Log at error level
    @inline(__always) @objc
    public static func e(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        log("E", OSLogType.error, message, file, line)
    }

    /// Internal formatting function
    @inline(__always)
    private static func log(_ prefix: String, _ type: OSLogType, _ message: String, _ file: String, _ line: UInt32) {
        var prefix = "\(Thread.isMainThread ? "+" : "-")\(prefix)| \(file):\(line)"
        #if DEBUG
            prefix = prefix.padding(toLength: 125, withPad: " ", startingAt: 0)
        #endif
        os_log("%@: %@", type: type, prefix, message)
    }
}
