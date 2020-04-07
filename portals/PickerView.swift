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
                PickerRowView(rowItem: application)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private protocol PickerRowViewModel {
    var _shortName: String { get }
    var _longName: String { get }
    var _icon: NSImage? { get }

    func onSelect()
}

extension ApplicationManager.Application: Identifiable, PickerRowViewModel {
    var id: pid_t { pid }

    var _shortName: String { name }
    var _longName: String { name }
    var _icon: NSImage? { icon }

    func onSelect() {
        print("selected")
    }
}

private struct PickerRowView: View {
    let rowItem: PickerRowViewModel

    var iconView: some View {
        if let icon = rowItem._icon {
            return AnyView(Image(nsImage: icon).resizable())
        } else {
            return AnyView(Rectangle().fill(Color.blue))
        }
    }

    var body: some View {
        HStack {
            Spacer(minLength: 4)
            Text(rowItem._shortName).frame(alignment: .trailing)
            Spacer().frame(width: 16)
            iconView.frame(width: 20, height: 20)
            Spacer().frame(width: 16)
            Text(rowItem._longName).frame(alignment: .leading)
            Spacer(minLength: 4)
        }.frame(width: 300, height: 30, alignment: .center)
            .onTapGesture(perform: rowItem.onSelect)
    }
}

#if DEBUG
struct PickerViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            PickerView()
            PickerRowView(rowItem: ApplicationManager.shared.getAll().first!)
                .previewLayout(.fixed(width: 300, height: 30))
            PickerRowView(rowItem: ApplicationManager.shared.getAll().last!)
                .previewLayout(.fixed(width: 300, height: 30))
        }
    }
}
#endif
