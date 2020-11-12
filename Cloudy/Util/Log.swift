// Copyright (c) 2020 Nomad5. All rights reserved.

import Foundation
import FirebaseCrashlytics
import os.log

/// Class for logging
public class Log: NSObject {

    /// Log at debug level
    @inline(__always)
    public static func d(_ message: @autoclosure () -> String, _ file: String = #file, _ line: UInt32 = #line) {
        #if DEBUG
            log("D", OSLogType.debug, message(), file, line)
        #endif
    }

    /// Log at info level
    @inline(__always)
    public static func i(_ message: @autoclosure () -> String, _ file: String = #file, _ line: UInt32 = #line) {
        #if DEBUG
            log("I", OSLogType.info, message(), file, line)
        #endif
    }

    /// Log at error level
    @inline(__always)
    public static func e(_ message: @autoclosure () -> String, _ file: String = #file, _ line: UInt32 = #line) {
        log("E", OSLogType.error, message(), file, line)
    }

    /// Internal formatting function
    @inline(__always)
    private static func log(_ prefix: String, _ type: OSLogType, _ message: String, _ file: String, _ line: UInt32) {
        var prefix = "\(Thread.isMainThread ? "+" : "-")\(prefix)| \(file):\(line)"
        #if DEBUG
            prefix = prefix.padding(toLength: 125, withPad: " ", startingAt: 0)
        #endif
        Crashlytics.crashlytics().log("\(prefix): \(message)")
        os_log("%@: %@", type: type, prefix, message)
    }
}

/// Objc extension
@objc extension Log {

    /// Log at debug level
    @inline(__always)
    public static func dObjc(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        Log.d(message, file, line)
    }

    /// Log at info level
    @inline(__always)
    public static func iObjc(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        Log.i(message, file, line)
    }

    /// Log at error level
    @inline(__always)
    public static func eObjc(_ message: String, _ file: String = #file, _ line: UInt32 = #line) {
        Log.e(message, file, line)
    }
}