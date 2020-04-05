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
    static let acceptedSubroles: Set<Subrole> = { Set([.standardWindow]) }()

    private init() {}

    /// Get all open windows with accepted subroles.
    func getAll() -> [Window] {
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
                let titleResult: PAXResult<String> = window.attribute(.title)
                guard let title = titleResult.success else {
                    print("ERROR: failed to get title of window \(window): \(titleResult.failure!)")
                    return nil
                }

                let subroleResult: PAXResult<String> = window.attribute(.subrole)
                guard let subrole = subroleResult.success else {
                    print("ERROR: failed to get subrole of windows \(window): \(subroleResult.failure!)")
                    return nil
                }

                if WindowManager.acceptedSubroles.contains(subrole) {
                    return Window(title: title, owner: runningApplication)
                } else {
                    return nil
                }
            }
        }
    }
}

extension WindowManager {
    struct Window: CustomStringConvertible {
        let title: String
        private let owner: NSRunningApplication

        var ownerPid: pid_t { return owner.processIdentifier }
        var ownerName: String? { return owner.localizedName }

        init(title: String, owner: NSRunningApplication) {
            self.title = title.isEmpty ? "NOTITLE" : title
            self.owner = owner
        }

        var description: String { "[\(self.ownerPid)]: \(self.title) (\(self.ownerName ?? "no owner name"))" }
    }
}

private extension Set where Element == Subrole {
    func contains(_ subroleString: String) -> Bool {
        guard let subrole = Subrole(rawValue: subroleString) else { return false }
        return contains(subrole)
    }
}
