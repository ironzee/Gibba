//
//  SelectField.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct SelectItem: Identifiable, Hashable {
  public let id = UUID()
  public let title: String
  public let value: String
  public init(_ title: String, value: String? = nil) { self.title = title; self.value = value ?? title }
}

public struct SelectField: View {
  @Binding var selection: String
  let items: [SelectItem]
  public var placeholder: String? = nil
  public var size: Size = .default

  public enum Size { case sm, `default` }

  public init(selection: Binding<String>, items: [SelectItem], placeholder: String? = nil, size: Size = .default) {
    self._selection = selection; self.items = items; self.placeholder = placeholder; self.size = size
  }

  public var body: some View {
    Menu {
      ForEach(items) { item in
        Button {
          selection = item.value
        } label: {
          HStack {
            if selection == item.value { Image(systemName: "checkmark") }
            Text(item.title)
          }
        }
      }
    } label: {
      HStack(spacing: 8) {
        Text(displayText)
          .lineLimit(1)
          .foregroundStyle(selection.isEmpty ? .secondary : .primary)
        Spacer(minLength: 8)
        Image(systemName: "chevron.down").foregroundStyle(.secondary)
      }
      .padding(.horizontal, 12)
      .frame(height: size == .default ? 36 : 32)
      .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
      .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.1)))
    }
    .buttonStyle(.plain)
  }

  private var displayText: String {
    if selection.isEmpty, let p = placeholder { return p }
    return items.first(where: { $0.value == selection })?.title ?? selection
  }
}
