//
//  Button.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct AppButtonStyle: ButtonStyle {
  public enum Variant { case `default`, destructive, outline, secondary, ghost, link }
  public enum Size { case `default`, sm, lg, icon }

  let variant: Variant
  let size: Size
  public init(variant: Variant = .default, size: Size = .default) {
    self.variant = variant; self.size = size
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: 14, weight: .medium))
      .padding(padding)
      .frame(height: height)
      .frame(minWidth: size == .icon ? height : nil)
      .background(background(configuration.isPressed))
      .foregroundStyle(foreground)
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(border, lineWidth: variant == .outline ? 1 : 0))
      .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      .opacity(configuration.isPressed ? 0.9 : 1)
      .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color(.quaternaryLabel), lineWidth: 0)
      )
      .accessibilityAddTraits(.isButton)
  }

  private var height: CGFloat {
    switch size { case .default: return 36; case .sm: return 32; case .lg: return 40; case .icon: return 36 }
  }
  private var padding: EdgeInsets {
    switch size {
      case .default: return .init(top: 8, leading: 16, bottom: 8, trailing: 16)
      case .sm:      return .init(top: 6, leading: 12, bottom: 6, trailing: 12)
      case .lg:      return .init(top: 10, leading: 20, bottom: 10, trailing: 20)
      case .icon:    return .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
  }
  private func background(_ pressed: Bool) -> some ShapeStyle {
    switch variant {
      case .default:    return (pressed ? Color.primary.opacity(0.9) : Color.primary).opacity(0.9)
      case .destructive:return (pressed ? Color.red.opacity(0.9) : Color.red)
      case .outline:    return Color(.systemBackground)
      case .secondary:  return Color(.secondarySystemBackground)
      case .ghost:      return pressed ? Color.black.opacity(0.07) : Color.clear
      case .link:       return Color.clear
    }
  }
  private var foreground: Color {
    switch variant {
      case .default, .destructive: return .white
      case .outline, .secondary, .ghost: return .primary
      case .link: return .blue
    }
  }
  private var border: Color {
    switch variant {
      case .outline: return Color.black.opacity(0.12)
      default: return .clear
    }
  }
}

public extension View {
  func appButton(variant: AppButtonStyle.Variant = .default,
                 size: AppButtonStyle.Size = .default) -> some View {
    buttonStyle(AppButtonStyle(variant: variant, size: size))
  }
}
