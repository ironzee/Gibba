//
//  DropdownMenu.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct DropdownItem: Identifiable {
  public let id = UUID()
  public let title: String
  public let systemImage: String?
  public let role: ButtonRole?
  public let action: () -> Void

  public init(
    _ title: String,
    systemImage: String? = nil,
    role: ButtonRole? = nil,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.systemImage = systemImage
    self.role = role
    self.action = action
  }
}

public struct DropdownMenu<MenuLabel: View>: View {
  @State private var isOpen = false
  let label: MenuLabel
  let items: [DropdownItem]

  public init(items: [DropdownItem], @ViewBuilder label: () -> MenuLabel) {
    self.items = items
    self.label = label()
  }

  public var body: some View {
    Menu {
      ForEach(items) { item in
        Button(role: item.role, action: item.action) {
          SwiftUI.Label(item.title, systemImage: item.systemImage ?? "circle")
        }
      }
    } label: {
      label
    }
  }
}
