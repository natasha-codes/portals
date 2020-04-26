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

    var pickerWindowController: WindowController!
    var preferencesWindowController: WindowController!
    var statusBarItem: NSStatusItem!

    func applicationWillResignActive(_ notification: Notification) {
        print("Portals will resign active")
        pickerWindowController.hide()
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
            self?.pickerWindowController.show()
        })
    }

    private func setupWindows() {
        pickerWindowController = WindowController(view: PickerView())
        preferencesWindowController = WindowController(view: PreferencesView(), styleMask: [.titled, .closable])
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
        preferencesWindowController.show()
    }

    @objc private func didTapQuit() {
        NSApp.terminate(nil)
    }
}
