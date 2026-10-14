//
//  MenubarView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum MenubarItemKind {
  case action(title: String, systemImage: String? = nil, role: ButtonRole? = nil, () -> Void)
  case checkbox(title: String, isOn: Binding<Bool>)
  case radioGroup(current: Binding<String>, options: [String], label: String)
  case divider
  case submenu(title: String, systemImage: String? = nil, items: [MenubarItemKind])
}

public struct MenubarView<MenuLabel: View>: View {
  let label: MenuLabel
  let items: [MenubarItemKind]

  public init(items: [MenubarItemKind], @ViewBuilder label: () -> MenuLabel) {
    self.items = items
    self.label = label()
  }

  public var body: some View {
    Menu {
      ForEach(Array(items.enumerated()), id: \.offset) { _, item in
        render(item: item)
      }
    } label: {
      label
    }
  }

  // Type-erased to avoid recursive opaque type issues
  private func render(item: MenubarItemKind) -> AnyView {
    switch item {

    case .action(let title, let systemImage, let role, let action):
      return AnyView(
        Button(role: role, action: action) {
          SwiftUI.Label(title, systemImage: systemImage ?? "circle")
        }
      )

    case .checkbox(let title, let isOn):
      return AnyView(
        Toggle(isOn: isOn) { Text(title) }
      )

    case .radioGroup(let current, let options, let label):
      return AnyView(
        Section(header: Text(label)) {
          ForEach(options, id: \.self) { opt in
            Button {
              current.wrappedValue = opt
            } label: {
              HStack {
                Image(systemName: current.wrappedValue == opt ? "smallcircle.filled.circle" : "circle")
                Text(opt)
              }
            }
          }
        }
      )

    case .divider:
      return AnyView(Divider())

    case .submenu(let title, let systemImage, let items):
      return AnyView(
        Menu {
          ForEach(Array(items.enumerated()), id: \.offset) { _, sub in
            render(item: sub) // safe now because we erased type
          }
        } label: {
          SwiftUI.Label(title, systemImage: systemImage ?? "folder")
        }
      )
    }
  }
}
