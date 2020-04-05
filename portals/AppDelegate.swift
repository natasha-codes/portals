//
//  AppDelegate.swift
//  portals
//
//  Created by Sasha Weiss on 3/31/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Cocoa
import SwiftUI
import MASShortcut
import AXSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard accessibilityPermissionsEnabled() else {
            print("ERROR: accessibility permissions not enabled")
            NSRunningApplication.current.terminate()
            return
        }

        print(WindowManager.shared.getAll())

        setupBindings()
        setupWindow()
    }

    private func accessibilityPermissionsEnabled() -> Bool {
        checkIsProcessTrusted(prompt: false)
    }

    private func setupBindings() {
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: "SummonPortals", toAction: {
            print("whoooooo we did a thing")
        })
    }

    private func setupWindow() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)

        window.center()
        window.setFrameAutosaveName("Main Window")

        window.contentView = NSHostingView(rootView: ContentView())
        window.makeKeyAndOrderFront(nil)
    }
}
