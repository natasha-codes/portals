//
//  KeypressManager.swift
//  portals
//
//  Created by Sasha Weiss on 4/29/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import AppKit
import MASShortcut

protocol KeypressManagerDelegate: class {
    func tabForwardPressed()
    func tabReleased()
}

class KeypressManager {

    weak var delegate: KeypressManagerDelegate?

    private var commandPressed: Bool = false

    private init() {
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: .tabForwardKey, toAction: { [weak self] in
            guard let self = self else { return }

            self.delegate?.tabForwardPressed()
        })

        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event -> NSEvent? in
            guard let self = self else { return event }

            if event.modifierFlags.intersects(with: .command) {
                // We have Command pressed
                self.commandPressed = true
            } else if self.commandPressed && !event.modifierFlags.intersects(with: .command) {
                // We had command pressed, but just released it
                self.commandPressed = false
                self.delegate?.tabReleased()
            }

            return event
        }
    }

    deinit {
        MASShortcutBinder.shared()?.breakBinding(withDefaultsKey: .tabForwardKey)
    }
}

extension KeypressManager {
    static let shared: KeypressManager = KeypressManager()
}

private extension String {
    static let tabForwardKey: String = "SummonPortals"
}

private extension NSEvent.ModifierFlags {
    func intersects(with other: NSEvent.ModifierFlags) -> Bool {
        self.intersection(other) == other
    }
}
