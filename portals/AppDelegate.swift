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

    var pickerWindowController: NSWindowController!
    var preferencesWindowController: NSWindowController!
    var statusBarItem: NSStatusItem!

    func applicationWillResignActive(_ notification: Notification) {
        print("Portals will resign active")
        pickerWindowController.window?.orderOut(nil)
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        print("Portals did become active")
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Portals did finish launching")

        guard setupApplication() else {
            NSApp.terminate(nil)
            return
        }

        setupBindings()
        setupWindows()
        setupMenuItem()
    }

    private func setupApplication() -> Bool {
        NSApp.setActivationPolicy(.accessory)

        guard checkIsProcessTrusted(prompt: false) else {
            print("ERROR: accessibility permissions not enabled")
            return false
        }

        return true
    }

    private func setupBindings() {
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: "SummonPortals", toAction: { [weak self] in
            guard let self = self else { return }
            
            self.activate(windowController: self.pickerWindowController)
        })
    }

    private func setupWindows() {
        pickerWindowController = createWindowController(withConstructor: PickerView.init)
        preferencesWindowController = createWindowController(withConstructor: PreferencesView.init, styleMask: [.titled, .closable])
    }

    private func createWindowController<T: View>(withConstructor ctor: () -> T, styleMask: NSWindow.StyleMask? = nil) -> NSWindowController {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1000, height: 1000),
                              styleMask: styleMask ?? [],
                              backing: .buffered,
                              defer: false,
                              screen: nil)

        window.contentView = NSHostingView(rootView: ctor())
        return NSWindowController(window: window)
    }

    private func setupMenuItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        statusBarItem.button?.title = "⛱"
        statusBarItem.menu = NSMenu(title: "Portals Status Bar Menu")

        statusBarItem.menu!.addItem(withTitle: "Preferences",
                                    action: #selector(didTapPreferences),
                                    keyEquivalent: "")

        let quitMenuItem = NSMenuItem(title: "Quit Portals", action: #selector(didTapQuit), keyEquivalent: "q")
        quitMenuItem.keyEquivalentModifierMask = .command
        statusBarItem.menu!.addItem(quitMenuItem)
    }

    @objc private func didTapPreferences() {
        activate(windowController: preferencesWindowController)
    }

    private func activate(windowController controller: NSWindowController) {
        controller.window?.center()
        controller.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func didTapQuit() {
        NSApp.terminate(nil)
    }
}
