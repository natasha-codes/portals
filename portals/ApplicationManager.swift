//
//  ApplicationManager.swift
//  portals
//
//  Created by Sasha Weiss on 4/2/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AppKit
import AXSwift

struct ApplicationManager {

    // MARK: Nested types

    struct Application: CustomStringConvertible {
        let windows: [Window]
        private let backingApplication: NSRunningApplication

        var pid: pid_t { backingApplication.processIdentifier }
        var name: String { backingApplication.localizedName ?? "" }

        fileprivate var isRelevant: Bool {
            backingApplication.activationPolicy == .regular || !windows.isEmpty
        }

        fileprivate init?(_ application: NSRunningApplication) {
            if application.activationPolicy == .prohibited {
                return nil
            }

            guard let applicationUiElement = AXSwift.Application(application) else {
                print("ERROR: failed to create application UIElement from running application \(application)")
                return nil
            }

            let windowsResult: PAXResult<[UIElement]> = applicationUiElement.windows()
            guard let windows = windowsResult.success else {
                print("ERROR: failed to get windows of application UIElement \(applicationUiElement): \(windowsResult.failure!)")
                return nil
            }

            self.windows = windows.compactMap({ Window($0) }).filter({ $0.isRelevant })
            self.backingApplication = application
        }

        var description: String {
            let prefix = "[\(pid) - \(name)]"

            if windows.isEmpty {
                return "\(prefix): no windows"
            } else {
                return "\(prefix): \(windows.map({ String(describing: $0) }).joined(separator: ", "))"
            }
        }
    }

    struct Window: CustomStringConvertible {
        let title: String
        private let subrole: Subrole

        fileprivate var isRelevant: Bool {
            subrole == .standardWindow
        }

        fileprivate init?(_ uiElement: UIElement) {
            let titleResult: PAXResult<String> = uiElement.attribute(.title)
            guard let title = titleResult.success else {
                print("ERROR: failed to get title of window UIElement \(uiElement): \(titleResult.failure!)")
                return nil
            }

            let subroleResult: PAXResult<String> = uiElement.attribute(.subrole)
            guard let subroleString = subroleResult.success else {
                print("ERROR: failed to get subrole of window UIElement \(uiElement): \(subroleResult.failure!)")
                return nil
            }

            guard let subrole = Subrole(rawValue: subroleString) else {
                print("ERROR: unexpected subrole: \(subroleString)")
                return nil
            }

            self.title = title
            self.subrole = subrole
        }

        var description: String { "\(title)" }
    }

    // MARK: Content

    static let shared: ApplicationManager = ApplicationManager()
    static let acceptedSubroles: Set<Subrole> = { Set([.standardWindow]) }()

    private init() {}

    /// Get all open applications.
    func getAll() -> [Application] {
        NSWorkspace.shared.runningApplications.compactMap({ Application($0) }).filter { $0.isRelevant }
    }
}

private extension Set where Element == Subrole {
    func contains(_ subroleString: String) -> Bool {
        guard let subrole = Subrole(rawValue: subroleString) else { return false }
        return contains(subrole)
    }
}
