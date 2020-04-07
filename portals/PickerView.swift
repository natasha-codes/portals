//
//  PickerView.swift
//  portals
//
//  Created by Sasha Weiss on 3/31/20.
//  Copyright © 2020 natasha-codes. All rights reserved.
//

import SwiftUI
import AppKit
import MASShortcut

struct PickerView: View {
    var body: some View {
        List {
            ForEach(ApplicationManager.shared.getAll()) { application in
                ApplicationRowGroupView(model: application.asGroupModel)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ApplicationRowGroupView: View {
    struct Model {
        let applicationRowModel: ApplicationRowView.Model
        let windowRowModels: [WindowRowView.Model]
    }

    let model: Model

    var body: some View {
        VStack {
            ApplicationRowView(model: model.applicationRowModel)
            ForEach(model.windowRowModels) { WindowRowView(model: $0) }
        }
    }
}

private struct ApplicationRowView: View {
    struct Model {
        let name: String
        let icon: NSImage?
        let onSelect: () -> Void
    }

    let model: Model

    private var iconView: some View {
        if let icon = model.icon {
            return AnyView(Image(nsImage: icon).resizable())
        } else {
            return AnyView(Rectangle().fill(Color.blue))
        }
    }

    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            iconView.frame(width: 20, height: 20)
            Spacer().frame(width: 16)
            Text(model.name).frame(alignment: .leading)
            Spacer(minLength: 4)
        }.frame(width: 300, height: 30, alignment: .center)
            .onTapGesture(perform: model.onSelect)
    }
}

private struct WindowRowView: View {
    struct Model: Identifiable {
        let id: String = UUID().uuidString
        let name: String
    }

    let model: Model

    var body: some View {
        Text("fdas")
    }
}

extension ApplicationManager.Application: Identifiable {
    var id: pid_t { pid }
}

private extension ApplicationManager.Application {
    var asGroupModel: ApplicationRowGroupView.Model {
        ApplicationRowGroupView.Model(applicationRowModel: asRowModel,
                                      windowRowModels: windows.map({ $0.asModel}))
    }

    var asRowModel: ApplicationRowView.Model {
        ApplicationRowView.Model(name: name, icon: icon, onSelect: { self.activate() })
    }
}

private extension ApplicationManager.Window {
    var asModel: WindowRowView.Model {
        WindowRowView.Model(name: title)
    }
}

#if DEBUG
struct PickerViewPreview: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
#endif
