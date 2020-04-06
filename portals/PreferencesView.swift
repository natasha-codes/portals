//
//  PreferencesView.swift
//  portals
//
//  Created by Sasha Weiss on 4/5/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import Foundation
import SwiftUI
import MASShortcut

struct PreferencesView: View {
    var body: some View {
        ShortcutView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ShortcutView: NSViewRepresentable {
    typealias NSViewType = MASShortcutView

    func makeNSView(context: Context) -> MASShortcutView {
        let shortcutView = MASShortcutView()
        shortcutView.associatedUserDefaultsKey = "SummonPortals"
        return shortcutView
    }

    func updateNSView(_ nsView: MASShortcutView, context: Context) {}
}

struct PreferencesViewPreviews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
