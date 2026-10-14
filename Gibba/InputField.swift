//
//  InputField.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct InputField: View {
  public enum State { case normal, disabled, invalid }
  public enum Kind { case text, secure }

  @Binding var text: String
  let placeholder: String
  let kind: Kind
  public var state: State = .normal
  public var prefix: AnyView? = nil
  public var suffix: AnyView? = nil

  @FocusState private var focused: Bool

  public init(_ placeholder: String,
              text: Binding<String>,
              kind: Kind = .text,
              state: State = .normal,
              prefix: AnyView? = nil,
              suffix: AnyView? = nil) {
    self.placeholder = placeholder
    self._text = text
    self.kind = kind
    self.state = state
    self.prefix = prefix
    self.suffix = suffix
  }

  public var body: some View {
    HStack(spacing: 8) {
      if let p = prefix { p }
      Group {
        if kind == .secure {
          SecureField(placeholder, text: $text)
            .focused($focused)
        } else {
          TextField(placeholder, text: $text)
            .focused($focused)
        }
      }
      .textInputAutocapitalization(.never)
      .disableAutocorrection(true)
      if let s = suffix { s }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .background(background, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(border, lineWidth: focused ? 2 : 1))
    .opacity(state == .disabled ? 0.5 : 1)
  }

  private var background: Color {
    switch state {
      case .normal, .disabled: return Color(.secondarySystemBackground)
      case .invalid: return Color.red.opacity(0.06)
    }
  }
  private var border: Color {
    switch state {
      case .invalid: return Color.red.opacity(0.6)
      default: return focused ? Color.accentColor.opacity(0.6) : Color.black.opacity(0.1)
    }
  }
}
