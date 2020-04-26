//
//  WindowController.swift
//  portals
//
//  Created by Sasha Weiss on 4/26/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI

// A wrapper around NSWindow and NSWindowController to provide a more unified interface
class WindowController {
    private let windowController: NSWindowController

    init<V: View>(view: V, styleMask: NSWindow.StyleMask? = nil) {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1000, height: 1000),
                              styleMask: styleMask ?? [],
                              backing: .buffered,
                              defer: false,
                              screen: nil)

        window.contentView = NSHostingView(rootView: view)

        windowController = NSWindowController(window: window)
    }

    func show() {
        windowController.window?.center()
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func hide() {
        windowController.window?.orderOut(nil)
    }
}
