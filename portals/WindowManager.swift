//
//  WindowManager.swift
//  portals
//
//  Created by Sasha Weiss on 4/2/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AppKit
import AXSwift

struct WindowManager {
    static let shared: WindowManager = WindowManager()

    private init() {}

    func getAllOpenWindows() -> [Window] {
        Application.all().flatMap { application -> [Window] in
            do {
                guard let windows = try application.windows() else {
                    print("WARNING: no error, but no windows returned")
                    return []
                }

                return []
            } catch let e {
                print("ERROR: failed to get windows for application \(application): \(e)")
                return []
            }
        }
    }
}

extension WindowManager {
    struct Window: CustomStringConvertible {
        let ownerPid: Int
        let ownerName: String?
        let title: String?

        var description: String { "[\(self.ownerPid)]: \(self.title ?? "no title") (\(self.ownerName ?? "no owner name"))" }
    }
}
