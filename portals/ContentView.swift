//
//  ContentView.swift
//  portals
//
//  Created by Sasha Weiss on 3/31/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import SwiftUI
import AppKit
import MASShortcut

struct ContentView: View {
    var body: some View {
        BindingsView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: self.queryRunningApplications)
    }

    private func queryRunningApplications() {
        print("hello")
    }
}

struct BindingsView: NSViewRepresentable {
    typealias NSViewType = MASShortcutView

    func makeNSView(context: Context) -> MASShortcutView {
        let shortcutView = MASShortcutView()
        shortcutView.associatedUserDefaultsKey = "SummonPortals"
        return shortcutView
    }
    
    func updateNSView(_ nsView: MASShortcutView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
