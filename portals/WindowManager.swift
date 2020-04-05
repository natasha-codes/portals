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

            let pidResult: PAXResult<pid_t> = application.pid()
            guard let pid = pidResult.success else {
                print("ERROR: failed to get pid of application \(application): \(pidResult.failure!)")
                return []
            }

            guard let runningApplication = NSRunningApplication(processIdentifier: pid) else {
                print("ERROR: failed to find running process for pid \(pid)")
                return []
            }

            let windowsResult: PAXResult<[UIElement]> = application.windows()
            guard let windows = windowsResult.success else {
                print("ERROR: failed to get windows of application \(application): \(windowsResult.failure!)")
                return []
            }

            return windows.compactMap { window -> Window? in
                let windowTitleResult: PAXResult<String> = window.attribute(.title)
                guard let windowTitle = windowTitleResult.success else {
                    print("ERROR: failed to get title of window \(window): \(windowTitleResult.failure!)")
                    return nil
                }

                print(window.attribute(.subrole).success!)

                return Window(owner: runningApplication, title: windowTitle)
            }
        }
    }
}

extension WindowManager {
    struct Window: CustomStringConvertible {
        private let owner: NSRunningApplication
        let title: String

        var ownerPid: pid_t { return owner.processIdentifier }
        var ownerName: String? { return owner.localizedName }

        init(owner: NSRunningApplication, title: String) {
            self.owner = owner
            self.title = title.isEmpty ? "NOTITLE" : title
        }

        var description: String { "[\(self.ownerPid)]: \(self.title) (\(self.ownerName ?? "no owner name"))" }
    }
}
