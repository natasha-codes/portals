//
//  AXSwift+Result.swift
//  portals
//
//  Created by Sasha Weiss on 4/5/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AXSwift

func unreachableError(message: String? = nil, inFile file: String = #file, onLine line: Int = #line) -> Never {
    let prefix = "[\(file):\(line)] Hit unreachable code!"

    if let message = message {
        fatalError("\(prefix) Message: \(message)")
    } else {
        fatalError(prefix)
    }
}

typealias AXResult<T> = Result<T, AXError>

private extension UIElement {
    func unreachable(error: Error, inFile file: String = #file, onLine line: Int = #line) -> Never {
        unreachableError(message: "Expected AXError, got: \(error)", inFile: file, onLine: line)
    }

    /// Coerces a throwing function with no arguments to a result type. Here, used specifically for AXSwift.UIElement methods.
    ///
    /// E.g. (outside the scope of AXSwift.UIElement):
    /// ```
    /// func foo() throws -> Int { throw "whoops" }
    /// let fooResult: Result<Int> = coerceThrow(foo)
    /// ```
    func coerceThrow<T>(_ f: () throws -> T) -> AXResult<T> {
        do {
            return .success(try f())
        } catch let e as AXError {
            return .failure(e)
        } catch let e {
            unreachable(error: e)
        }
    }
}

extension UIElement {
    func pid() -> AXResult<pid_t> {
        coerceThrow(pid)
    }

    func attribute<T>(_ attr: Attribute) -> AXResult<T?> {
        return coerceThrow { try attribute(attr) }
    }
}

extension Application {
    func windows() -> AXResult<[UIElement]?> {
        coerceThrow(windows)
    }
}
