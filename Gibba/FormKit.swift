//
//  FormKit.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

// Root container providing spacing + optional title/description regions.

public struct FormRoot<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    VStack(alignment: .leading, spacing: 16) { content }
      .padding(16)
      .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.06)))
  }
}

public struct FormField<Title: View, Content: View, Description: View>: View {
  let title: Title
  let content: Content
  let description: Description
  public init(@ViewBuilder title: () -> Title,
              @ViewBuilder content: () -> Content,
              @ViewBuilder description: () -> Description = { EmptyView() }) {
    self.title = title(); self.content = content(); self.description = description()
  }
  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      title
      content
      description.opacity(0.8).font(.system(size: 12)).foregroundStyle(.secondary)
    }
  }
}

public struct TextFieldStyled: View {
  @Binding var text: String
  public var placeholder: String
  public var isSecure: Bool = false
  public init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false) {
    self.placeholder = placeholder; self._text = text; self.isSecure = isSecure
  }
  public var body: some View {
    Group {
      if isSecure {
        SecureField(placeholder, text: $text)
      } else {
        TextField(placeholder, text: $text)
      }
    }
    .textInputAutocapitalization(.none)
    .disableAutocorrection(true)
    .padding(12)
    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08)))
  }
}

public struct ToggleStyled: View {
  @Binding var isOn: Bool
  public let label: String

  public init(_ label: String, isOn: Binding<Bool>) {
    self.label = label
    self._isOn = isOn
  }

  public var body: some View {
    Toggle(isOn: $isOn) { Text(label) }
      .modifier(ToggleTintCompat(.blue))
  }
}

// Cross‑OS tint helper so we don't rely on SwitchToggleStyle(tint:)
private struct ToggleTintCompat: ViewModifier {
  let color: Color
  init(_ color: Color) { self.color = color }

  func body(content: Content) -> some View {
    if #available(iOS 15.0, macOS 12.0, *) {
      // Modern API: .tint works directly on Toggle
      content.tint(color)
    } else {
      // Older OS: use accentColor and keep the default switch style
      content
        .toggleStyle(SwitchToggleStyle())
        .accentColor(color)
    }
  }

}
