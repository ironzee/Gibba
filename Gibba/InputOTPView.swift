//
//  InputOTPView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct InputOTPView: View {
  public enum Style { case boxes, underline }
  @Binding var value: String
  let length: Int
  let style: Style
  public var isDisabled: Bool = false
  public var isInvalid: Bool = false
  public var onComplete: ((String) -> Void)?

  @FocusState private var focusedIndex: Int?
  @State private var chars: [String]

  public init(value: Binding<String>, length: Int = 6, style: Style = .boxes, isDisabled: Bool = false, isInvalid: Bool = false, onComplete: ((String) -> Void)? = nil) {
    self._value = value
    self.length = max(1, length)
    self.style = style
    self.isDisabled = isDisabled
    self.isInvalid = isInvalid
    self.onComplete = onComplete
    self._chars = State(initialValue: Array(repeating: "", count: max(1, length)))
  }

  public var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<length, id: \.self) { i in
        ZStack {
          // Hidden text field per slot
          TextField("", text: Binding(
            get: { chars[i] },
            set: { newVal in
              guard !isDisabled else { return }
              let filtered = newVal.filter(\.isNumber).prefix(1)
              chars[i] = String(filtered)
              value = chars.joined()
              if filtered.count == 1 {
                if i < length - 1 {
                  focusedIndex = i + 1
                } else {
                  focusedIndex = nil
                  onComplete?(value)
                }
              }
            })
          )
          .keyboardType(.numberPad)
          .textContentType(.oneTimeCode)
          .focused($focusedIndex, equals: i)
          .frame(width: 0, height: 0)
          .opacity(0.01)
          // Visual slot
          slotView(text: chars[i], isFocused: focusedIndex == i)
        }
        .onTapGesture { if !isDisabled { focusedIndex = i } }
      }
    }
    .onChange(of: value) { _, new in
      let arr = Array(new.prefix(length))
      for i in 0..<length { chars[i] = i < arr.count ? String(arr[i]) : "" }
    }
    .onAppear {
      let arr = Array(value.prefix(length))
      for i in 0..<length { chars[i] = i < arr.count ? String(arr[i]) : "" }
    }
    .disabled(isDisabled)
    .opacity(isDisabled ? 0.5 : 1)
  }

  @ViewBuilder private func slotView(text: String, isFocused: Bool) -> some View {
    switch style {
      case .boxes:
        ZStack {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color(.secondarySystemBackground))
          RoundedRectangle(cornerRadius: 10)
            .stroke(isInvalid ? Color.red.opacity(0.5) : (isFocused ? Color.accentColor.opacity(0.6) : Color.black.opacity(0.08)), lineWidth: isFocused ? 2 : 1)
          Text(text.isEmpty ? " " : text)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
        }
        .frame(width: 44, height: 52)
      case .underline:
        VStack(spacing: 6) {
          Text(text.isEmpty ? " " : text)
            .font(.system(size: 20, weight: .semibold, design: .rounded))
          Rectangle()
            .fill(isInvalid ? Color.red : (isFocused ? Color.accentColor : Color.black.opacity(0.15)))
            .frame(height: isFocused ? 3 : 2)
        }
        .frame(width: 36, height: 48)
    }
  }
}
