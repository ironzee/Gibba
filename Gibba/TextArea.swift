//
//  TextArea.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct TextAreaStyle {
  public var minHeight: CGFloat = 64
  public var cornerRadius: CGFloat = 10
  public var borderColor: Color = Color.black.opacity(0.12)
  public var fillColor: Color = Color(.secondarySystemBackground)
  public var focusedRingColor: Color = .primary.opacity(0.5)
  public init() {}
}

public struct TextArea: View {
  @Binding var text: String
  public var placeholder: String = ""
  public var isDisabled: Bool = false
  public var isInvalid: Bool = false
  public var style: TextAreaStyle = .init()
  @FocusState private var focused: Bool

  public init(text: Binding<String>,
              placeholder: String = "",
              isDisabled: Bool = false,
              isInvalid: Bool = false,
              style: TextAreaStyle = .init()) {
    self._text = text
    self.placeholder = placeholder
    self.isDisabled = isDisabled
    self.isInvalid = isInvalid
    self.style = style
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      if text.isEmpty {
        Text(placeholder)
          .foregroundStyle(.secondary)
          .padding(.horizontal, 12)
          .padding(.vertical, 10)
      }
      TextEditor(text: $text)
        .focused($focused)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(minHeight: style.minHeight, alignment: .topLeading)
        .background(style.fillColor, in: RoundedRectangle(cornerRadius: style.cornerRadius))
        .overlay(
          RoundedRectangle(cornerRadius: style.cornerRadius)
            .stroke(isInvalid ? Color.red : style.borderColor, lineWidth: 1)
        )
        .overlay(
          RoundedRectangle(cornerRadius: style.cornerRadius)
            .stroke(focused ? style.focusedRingColor : .clear, lineWidth: 3)
            .opacity(focused ? 1 : 0)
        )
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
    .font(.system(size: 16))
  }
}
