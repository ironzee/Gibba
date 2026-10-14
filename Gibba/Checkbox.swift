//
//  Checkbox.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Checkbox: View {
  @Binding var isOn: Bool
  public var isDisabled: Bool = false
  public init(isOn: Binding<Bool>, isDisabled: Bool = false) { self._isOn = isOn; self.isDisabled = isDisabled }

  public var body: some View {
    Button {
      guard !isDisabled else { return }
      withAnimation(.easeInOut(duration: 0.12)) { isOn.toggle() }
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
          .fill(isOn ? Color.primary : Color(.secondarySystemBackground))
        RoundedRectangle(cornerRadius: 4).stroke(isOn ? Color.primary : Color.black.opacity(0.15))
        if isOn {
          Image(systemName: "checkmark")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(Color.white)
        }
      }
      .frame(width: 16, height: 16)
      .shadow(color: Color.black.opacity(0.06), radius: 1, x: 0, y: 1)
    }
    .buttonStyle(.plain)
    .opacity(isDisabled ? 0.5 : 1)
    .accessibilityLabel(Text(isOn ? "Checked" : "Unchecked"))
    .accessibilityAddTraits(.isButton)
  }
}
