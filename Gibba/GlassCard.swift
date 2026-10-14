//
//  GlassCard.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import SwiftUI

public struct GlassCard<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }

  public var body: some View {
    VStack(spacing: 16) {
      content
    }
    .padding(.vertical, 0)
    .background(
      RoundedRectangle(cornerRadius: 22, style: .continuous)
        .fill(.ultraThinMaterial)                          // “glass” plate
        .overlay(                                          // soft outline
          RoundedRectangle(cornerRadius: 22, style: .continuous)
            .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
    )
  }
}

// Slots
public struct CardHeader<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    VStack(alignment: .leading, spacing: 6) { content }
      .padding(.top, 24)
      .padding(.horizontal, 24)
  }
}

public struct CardTitle: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View {
    Text(text)
      .font(.system(size: 16, weight: .medium))
      .lineLimit(1)
  }
}

public struct CardDescription: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View {
    Text(text)
      .foregroundStyle(.secondary)
      .font(.system(size: 14, weight: .regular))
  }
}

public struct CardAction<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { content }
}

public struct CardContent<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) { content }
      .padding(.horizontal, 24)
      .padding(.bottom, 24)
  }
}

public struct CardFooter<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    HStack { content }
      .padding(.horizontal, 24)
      .padding(.bottom, 24)
  }
}
