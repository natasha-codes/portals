//
//  AXSwift+Result.swift
//  portals
//
//  Created by Sasha Weiss on 4/5/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AXSwift

/// Portals AXError
enum PAXError: Error {
    case noValue
    case real(AXError)
}

typealias PAXResult<T> = Result<T, PAXError>

private extension UIElement {
    private func unreachable(message: String? = nil, inFile file: String = #file, onLine line: Int = #line) -> Never {
        let prefix = "[\(file):\(line)] Hit unreachable code!"

        if let message = message {
            fatalError("\(prefix) Message: \(message)")
        } else {
            fatalError(prefix)
        }
    }

    /// Coerces a throwing function to a result type. Specifically for AXSwift.UIElement methods.
    ///
    /// E.g. (outside the scope of AXSwift.UIElement):
    /// ```
    /// func foo() throws -> Int { throw "whoops" }
    /// let fooResult: Result<Int> = coerceThrow(foo)
    /// ```
    func coerceThrow<T>(_ f: () throws -> T?) -> PAXResult<T> {
        do {
            if let value = try f() {
                return .success(value)
            } else {
                return .failure(.noValue)
            }
        } catch let e as AXError {
            return .failure(.real(e))
        } catch let e {
            unreachable(message: "Expected AXError, got: \(e)")
        }
    }
}

extension UIElement {
    func pid() -> PAXResult<pid_t> {
        coerceThrow(pid)
    }

    func attribute<T>(_ attr: Attribute) -> PAXResult<T> {
        return coerceThrow { try attribute(attr) }
    }
}

extension Application {
    func windows() -> PAXResult<[UIElement]> {
        coerceThrow(windows)
    }
}
