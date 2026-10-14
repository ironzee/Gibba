//
//  Badge.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Badge<Content: View>: View {
  public enum Variant { case `default`, secondary, destructive, outline }
  let variant: Variant
  let content: Content

  public init(variant: Variant = .default, @ViewBuilder content: () -> Content) {
    self.variant = variant; self.content = content()
  }

  public var body: some View {
    HStack(spacing: 6) { content.font(.system(size: 12, weight: .medium)) }
      .padding(.horizontal, 8).padding(.vertical, 4)
      .background(background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(border))
      .foregroundStyle(foreground)
  }

  private var background: Color {
    switch variant {
      case .default: return Color.black.opacity(0.9)
      case .secondary: return Color(.systemGray6)
      case .destructive: return Color.red
      case .outline: return Color.clear
    }
  }
  private var border: Color {
    switch variant {
      case .default, .secondary: return Color.black.opacity(0.1)
      case .destructive: return Color.red.opacity(0.4)
      case .outline: return Color.black.opacity(0.2)
    }
  }
  private var foreground: Color {
    switch variant {
      case .default: return .white
      case .secondary, .outline: return .primary
      case .destructive: return .white
    }
  }
}
