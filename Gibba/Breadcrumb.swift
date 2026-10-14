//
//  Breadcrumb.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

// Simple, flexible breadcrumb set mirroring your TSX API.

public struct Breadcrumb<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    NavigationStack { content }
      .accessibilityLabel("breadcrumb")
  }
}

public struct BreadcrumbList<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    HStack(spacing: 8) { content }
      .font(.system(size: 14))
      .foregroundStyle(.secondary)
      .lineLimit(1)
  }
}

public struct BreadcrumbItem<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { HStack(spacing: 6) { content } }
}

public struct BreadcrumbLink<Label: View>: View {
  let action: () -> Void
  let label: Label
  public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
    self.action = action; self.label = label()
  }
  public var body: some View {
    Button(action: action) { label.foregroundStyle(.primary) }
      .buttonStyle(.plain)
      .hoverEffect(.highlight)
  }
}

public struct BreadcrumbPage: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).fontWeight(.regular).foregroundStyle(.primary) }
}

public struct BreadcrumbSeparator: View {
  public init() {}
  public var body: some View {
    Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundStyle(.secondary)
  }
}

public struct BreadcrumbEllipsis: View {
  public init() {}
  public var body: some View {
    Image(systemName: "ellipsis").font(.system(size: 14, weight: .regular)).frame(width: 24, height: 24)
      .accessibilityHidden(true)
  }
}
