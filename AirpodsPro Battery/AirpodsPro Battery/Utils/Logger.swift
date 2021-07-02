//
//  Logger.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 02/07/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

public enum Logger {

    /// A date formatter used to create the timestamp in the log.
    ///
    /// This formatter is only created if it is actually used, reducing the
    /// overhead to zero.
    static var formatter: DateFormatter?

    // MARK: - API

    /// Call to print message in debug area.
    ///
    /// Asserts are removed in release builds, which make
    /// the function body empty, which caused all calls to
    /// be removed as well.
    ///
    /// Result is zero overhead for release builds.
    public static func da(_ message: String) {
        assert(debugAreaPrint(message))
    }

    // MARK: - Helpers

    /// The function that actually does the printing. It returns `true` to
    /// prevent the assert from kicking in on debug builds.
    private static func debugAreaPrint(_ message: String) -> Bool {
        print("\(timestamp) - \(message)")
        return true
    }

    /// Creates a timestamp used as part of the temporary logging in the debug area.
    static private var timestamp: String {

        if formatter == nil {
            formatter = DateFormatter()
            formatter!.dateFormat = "HH:mm:ss.SSS"
        }

        let date = Date()
        return formatter!.string(from: date)
    }
}
