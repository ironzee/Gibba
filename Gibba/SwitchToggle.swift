//
//  SwitchToggle.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct SwitchToggleStyle: ToggleStyle {
  public var onColor: Color = .primary
  public var offColor: Color = Color.black.opacity(0.18)
  public var thumbColor: Color = .white
  public var size: CGSize = .init(width: 52, height: 32)

  public func makeBody(configuration: Configuration) -> some View {
    let isOn = configuration.isOn
    return Button {
      withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
        configuration.isOn.toggle()
      }
    } label: {
      ZStack(alignment: isOn ? .trailing : .leading) {
        Capsule()
          .fill(isOn ? onColor : offColor)
          .frame(width: size.width, height: size.height)
        Circle()
          .fill(thumbColor)
          .frame(width: size.height - 6, height: size.height - 6)
          .padding(3)
          .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
      }
    }
    .buttonStyle(.plain)
    .accessibilityValue(isOn ? "On" : "Off")
  }
}

public extension ToggleStyle where Self == SwitchToggleStyle {
  static var appSwitch: SwitchToggleStyle { SwitchToggleStyle() }
}

// Example container
public struct SwitchToggle: View {
  @Binding var isOn: Bool
  public init(isOn: Binding<Bool>) { self._isOn = isOn }
  public var body: some View { Toggle("", isOn: $isOn).toggleStyle(.appSwitch) }
}
