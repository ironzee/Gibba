//
//  ToggleGroup.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct ToggleGroupContextStyle {
  public var variant: ToggleButtonVariant = .default
  public var size: ToggleButtonSize = .default
  public init(variant: ToggleButtonVariant = .default, size: ToggleButtonSize = .default) {
    self.variant = variant; self.size = size
  }
}

public struct ToggleGroupItemModel: Identifiable, Hashable {
  public let id = UUID()
  public let value: String
  public let label: String
  public init(_ value: String, label: String? = nil) { self.value = value; self.label = label ?? value }
}

/// Single-select (Radix: type="single")
public struct ToggleGroupSingle: View {
  @Binding var selection: String?
  let items: [ToggleGroupItemModel]
  public var style: ToggleGroupContextStyle = .init()

  public init(selection: Binding<String?>, items: [ToggleGroupItemModel], style: ToggleGroupContextStyle = .init()) {
    self._selection = selection; self.items = items; self.style = style
  }

  public var body: some View {
    HStack(spacing: 0) {
      ForEach(items) { item in
        ToggleButton(isOn: .init(
          get: { selection == item.value },
          set: { on in selection = on ? item.value : nil }
        ), style: .init(variant: style.variant, size: style.size)) {
          Text(item.label)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
        .contentShape(Rectangle())
        .background(Color(.secondarySystemBackground))
        .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.black.opacity(0.06)))
        .clipShape(RoundedRectangle(cornerRadius: 0))
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
  }
}

/// Multi-select (Radix: type="multiple")
public struct ToggleGroupMultiple: View {
  @Binding var selection: Set<String>
  let items: [ToggleGroupItemModel]
  public var style: ToggleGroupContextStyle = .init()

  public init(
    selection: Binding<Set<String>>,
    items: [ToggleGroupItemModel],
    style: ToggleGroupContextStyle = .init()
  ) {
    self._selection = selection
    self.items = items
    self.style = style
  }

  public var body: some View {
    HStack(spacing: 0) {
      ForEach(items) { item in
        ToggleButton(
          isOn: .init(
            get: { selection.contains(item.value) },
            set: { on in
              if on {
                _ = selection.insert(item.value)   // ignore tuple (inserted/memberAfterInsert)
              } else {
                _ = selection.remove(item.value)   // ignore optional
              }
            }
          ),
          style: .init(variant: style.variant, size: style.size)
        ) {
          Text(item.label)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
        }
        .contentShape(Rectangle())
        .background(Color(.secondarySystemBackground))
        .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.black.opacity(0.06)))
        .clipShape(RoundedRectangle(cornerRadius: 0))
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
  }
}

