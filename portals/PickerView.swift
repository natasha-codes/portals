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

private extension CGFloat {
    static let applicationIconSpacing: CGFloat = 16
    static let applicationIconSize: CGFloat = 20

    static let rowWidth: CGFloat = 800
    static let rowHeight: CGFloat = 30
    static let rowMinTrailingSpacing: CGFloat = 16
}

struct PickerView: View {
    let applications = ApplicationManager.shared.getAll()

    var body: some View {
        List {
            ForEach(applications) { application in
                ApplicationRowGroupView(model: application.asGroupModel)
                    .listRowInsets(EdgeInsets())
            }
        }
        .frame(width: .rowWidth)
    }
}

private struct ApplicationRowGroupView: View {
    struct Model {
        let applicationRowModel: ApplicationRowView.Model
        let windowRowModels: [WindowRowView.Model]
    }

    let model: Model

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ApplicationRowView(model: model.applicationRowModel)
                .frame(width: .rowWidth,
                       height: .rowHeight,
                       alignment: .leading)
            ForEach(model.windowRowModels) { WindowRowView(model: $0) }
                .frame(width: .rowWidth,
                       height: .rowHeight,
                       alignment: .leading)
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
            Spacer().frame(width: .applicationIconSpacing)
            iconView.frame(width: .applicationIconSize, height: .applicationIconSize)
            Spacer().frame(width: .applicationIconSpacing)
            Text(model.name).frame(alignment: .leading)
            Spacer(minLength: .rowMinTrailingSpacing)
        }
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
        HStack {
            Spacer().frame(width: .applicationIconSize + (.applicationIconSpacing * 2))
            Text(model.name)
            Spacer(minLength: .rowMinTrailingSpacing)
        }
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
