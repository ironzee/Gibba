
//  GlassButtonStyle.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum ButtonVariant {
  case `default`, destructive, outline, secondary, ghost, link
}

public enum ButtonSize {
  case sm, `default`, lg, icon
}

public struct GlassButtonStyle: ButtonStyle {
  let variant: ButtonVariant
  let size: ButtonSize
  let isInvalid: Bool

  public init(variant: ButtonVariant = .default,
              size: ButtonSize = .default,
              isInvalid: Bool = false) {
    self.variant = variant
    self.size = size
    self.isInvalid = isInvalid
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: fontSize, weight: .medium))
      .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
      .padding(.horizontal, horizontalPadding)
      .frame(height: height)
      .frame(minWidth: size == .icon ? height : nil, minHeight: height)
      .foregroundColor(foregroundColor)
      .background(background(configuration: configuration))
      .overlay(borderOverlay)
      .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
      .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
      .opacityDisabled()
      .accessibilityAddTraits(.isButton)
  }

  // MARK: - Tokens (no Theme dependency)

  private var fontSize: CGFloat { 15 } // similar to "base"
  private var cornerRadius: CGFloat {
    switch size {
      case .sm: return 10
      case .default, .icon: return 12
      case .lg: return 14
    }
  }

  private var height: CGFloat {
    switch size {
      case .sm: return 28        // ~ h-8
      case .default, .icon: return 32 // ~ h-9
      case .lg: return 36        // ~ h-10
    }
  }

  private var horizontalPadding: CGFloat {
    switch size {
      case .sm: return 12  // px-3
      case .default: return 16 // px-4
      case .lg: return 24  // px-6
      case .icon: return 0
    }
  }

  private var foregroundColor: Color {
    switch variant {
      case .default:   return .white
      case .destructive: return .white
      case .outline:   return .primary
      case .secondary: return .primary
      case .ghost:     return .accentColor
      case .link:      return .accentColor
    }
  }

  // MARK: - Backgrounds

  @ViewBuilder
  private func background(configuration: Configuration) -> some View {
    let pressedOpacity: Double = configuration.isPressed ? 0.9 : 1.0

    switch variant {
      case .default:
        Color.accentColor
          .opacity(pressedOpacity)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

      case .destructive:
        Color.red
          .opacity(pressedOpacity)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

      case .outline:
        // transparent fill over a subtle material plate
        (Color.clear)
          .background(.ultraThinMaterial)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

      case .secondary:
        // soft filled neutral
        Color.secondary.opacity(configuration.isPressed ? 0.18 : 0.22)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

      case .ghost:
        // very light accent tint
        Color.accentColor.opacity(configuration.isPressed ? 0.10 : 0.14)
          .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

      case .link:
        Color.clear
    }
  }

  // MARK: - Border

  @ViewBuilder
  private var borderOverlay: some View {
    switch variant {
      case .outline:
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(Color.primary.opacity(0.15), lineWidth: 1)
      default:
        EmptyView()
    }
  }
}

private extension View {
  @ViewBuilder func opacityDisabled() -> some View {
    // Keep as a hook; external .disabled(true) will auto-dim
    self
  }
}
