//
//  AlertView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct AlertView<Content: View>: View {
  public enum Variant { case `default`, destructive }
  let variant: Variant
  let content: Content
  let icon: Image?

  public init(variant: Variant = .default, icon: Image? = nil, @ViewBuilder content: () -> Content) {
    self.variant = variant; self.icon = icon; self.content = content()
  }

  public var body: some View {
    HStack(alignment: .top, spacing: 12) {
      if let icon = icon { icon.font(.system(size: 14, weight: .semibold)) }
      VStack(alignment: .leading, spacing: 4) { content }
      Spacer(minLength: 0)
    }
    .padding(.vertical, 12).padding(.horizontal, 16)
    .background(background, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(border))
  }

  private var background: Color {
    switch variant {
      case .default: return .white
      case .destructive: return .white
    }
  }
  private var border: Color {
    switch variant {
      case .default: return Color.black.opacity(0.12)
      case .destructive: return Color.red.opacity(0.35)
    }
  }
}

public struct AlertTitle: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).font(.system(size: 14, weight: .semibold)) }
}

public struct AlertDescription<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { VStack(alignment: .leading, spacing: 4) { content }.font(.system(size: 13)).foregroundStyle(.secondary) }
}
