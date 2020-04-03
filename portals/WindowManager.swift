//
//  WindowManager.swift
//  portals
//
//  Created by Sasha Weiss on 4/2/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AppKit

struct WindowManager {
    static let shared: WindowManager = WindowManager()

    private init() {}

    func getWindows() -> [Window] {
        guard let windowDicts = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as? [[String: Any]] else {
            print("ERROR: failed to get windows")
            return []
        }

        return windowDicts.compactMap { dict in
            guard let ownerPid = dict[kCGWindowOwnerPID as String] as? NSNumber else {
                print("ERROR: failed to find window owner PID")
                return nil
            }

            return Window(ownerPid: ownerPid.intValue,
                          ownerName: dict[kCGWindowOwnerName as String] as? String,
                          title: dict[kCGWindowName as String] as? String)
        }
    }

    func getRunningApplications() -> [Application] {
        NSWorkspace.shared.runningApplications.map { application in
            let pid = Int(application.processIdentifier)
            let bundleId = application.bundleIdentifier ?? "no bundle id"
            let name = application.localizedName ?? "no name"

            return Application(pid: pid, bundleId: bundleId, name: name)
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

    struct Application: CustomStringConvertible {
        let pid: Int
        let bundleId: String
        let name: String

        var description: String { "[\(self.pid)]: \(self.bundleId) - \(self.name)" }
    }
}
