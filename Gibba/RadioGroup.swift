//
//  RadioGroup.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct RadioOption: Identifiable, Hashable {
  public let id = UUID()
  public let value: String
  public let label: String
  public init(_ value: String, label: String? = nil) { self.value = value; self.label = label ?? value }
}

public struct RadioGroup: View {
  @Binding var selection: String
  let options: [RadioOption]
  public var invalid: Bool = false
  public var spacing: CGFloat = 12

  public init(selection: Binding<String>, options: [RadioOption], invalid: Bool = false) {
    self._selection = selection; self.options = options; self.invalid = invalid
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: spacing) {
      ForEach(options) { opt in
        RadioGroupItem(isSelected: selection == opt.value,
                       label: opt.label,
                       invalid: invalid) { selection = opt.value }
      }
    }
  }
}

public struct RadioGroupItem: View {
  let isSelected: Bool
  let label: String
  var invalid: Bool = false
  let action: () -> Void

  public var body: some View {
    Button(action: action) {
      HStack(spacing: 10) {
        ZStack {
          Circle()
            .strokeBorder(invalid ? Color.red : Color.secondary.opacity(0.35), lineWidth: 1)
            .background(Circle().fill(Color(.secondarySystemBackground)))
            .frame(width: 18, height: 18)
          if isSelected { Circle().fill(Color.primary).frame(width: 10, height: 10) }
        }
        Text(label).foregroundStyle(.primary)
        Spacer()
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}
