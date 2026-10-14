//
//  ToggleButton.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum ToggleButtonVariant { case `default`, outline }
public enum ToggleButtonSize { case sm, `default`, lg }

public struct ToggleButtonStyleConfig {
  public var variant: ToggleButtonVariant = .default
  public var size: ToggleButtonSize = .default
  public init(variant: ToggleButtonVariant = .default, size: ToggleButtonSize = .default) {
    self.variant = variant; self.size = size
  }
}

public struct ToggleButton<Label: View>: View {
  @Binding var isOn: Bool
  public var style: ToggleButtonStyleConfig = .init()
  public var disabled: Bool = false
  public let label: () -> Label

  public init(isOn: Binding<Bool>,
              style: ToggleButtonStyleConfig = .init(),
              disabled: Bool = false,
              @ViewBuilder label: @escaping () -> Label) {
    self._isOn = isOn; self.style = style; self.disabled = disabled; self.label = label
  }

  private var paddings: (h: CGFloat, v: CGFloat) {
    switch style.size {
      case .sm: return (h: 6, v: 6)
      case .default: return (h: 8, v: 8)
      case .lg: return (h: 10, v: 10)
    }
  }

  public var body: some View {
    Button {
      guard !disabled else { return }
      withAnimation(.easeInOut(duration: 0.15)) { isOn.toggle() }
    } label: {
      HStack(spacing: 8) { label() }
        .font(.system(size: 14, weight: .medium))
        .frame(minHeight: height)
        .padding(.horizontal, paddings.h)
        .padding(.vertical, paddings.v)
        .background(background)
        .foregroundStyle(foreground)
        .overlay(border)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .opacity(disabled ? 0.5 : 1)
    }
    .buttonStyle(.plain)
    .accessibilityValue(isOn ? "On" : "Off")
  }

  private var height: CGFloat { switch style.size { case .sm: 32; case .default: 36; case .lg: 40 } }

  private var background: some ShapeStyle {
    if isOn { return AnyShapeStyle(Color.accentColor.opacity(0.12)) }
    switch style.variant {
      case .default: return AnyShapeStyle(Color.clear)
      case .outline: return AnyShapeStyle(Color.clear)
    }
  }

  private var border: some View {
    RoundedRectangle(cornerRadius: 10)
      .stroke(isOn ? Color.accentColor : (style.variant == .outline ? Color.black.opacity(0.12) : .clear), lineWidth: 1)
  }

  private var foreground: Color {
    isOn ? .accentColor : .primary
  }
}
