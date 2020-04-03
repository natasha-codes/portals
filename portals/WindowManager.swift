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

    func getRunningApplications() -> [Application] {
        NSWorkspace.shared.runningApplications.map { application in
            let pid = application.processIdentifier
            let bundleId = application.bundleIdentifier ?? "no bundle id"
            let name = application.localizedName ?? "no name"

            return Application(pid: pid, bundleId: bundleId, name: name)
        }
    }
}

extension WindowManager {
    struct Application {
        let pid: pid_t
        let bundleId: String
        let name: String
    }
}
