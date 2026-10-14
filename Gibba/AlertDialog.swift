//
//  AlertDialog.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

// SwiftUI overlay version of Radix AlertDialog.
// Usage:
// @State var show = false
// AlertDialog(isPresented: $show) {
//   AlertDialogHeader {
//     AlertDialogTitle("Delete item")
//     AlertDialogDescription("This action cannot be undone.")
//   }
//   AlertDialogFooter {
//     AlertDialogCancel("Cancel") { show = false }
//     AlertDialogAction("Delete", role: .destructive) { /* delete */ }
//   }
// }

public struct AlertDialog<Content: View>: View {
  @Binding var isPresented: Bool
  let content: Content

  public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self._isPresented = isPresented
    self.content = content()
  }

  public var body: some View {
    ZStack {
      if isPresented {
        Color.black.opacity(0.5)
          .ignoresSafeArea()
          .transition(.opacity)
          .onTapGesture {} // swallow

        VStack(spacing: 16) {
          content
        }
        .frame(maxWidth: 560)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.1)))
        .shadow(radius: 24)
        .padding(.horizontal, 16)
        .transition(.scale.combined(with: .opacity))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: isPresented)
  }
}

// Trigger helper (optional): wrap any label to present.
public struct AlertDialogTrigger<Label: View>: View {
  @Binding var isPresented: Bool
  let label: Label
  public init(isPresented: Binding<Bool>, @ViewBuilder label: () -> Label) {
    self._isPresented = isPresented; self.label = label()
  }
  public var body: some View {
    Button { isPresented = true } label: { label }
  }
}

public struct AlertDialogHeader<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { VStack(alignment: .leading, spacing: 8) { content } }
}

public struct AlertDialogFooter<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    HStack(spacing: 8) {
      Spacer()
      content
    }
  }
}

public struct AlertDialogTitle: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).font(.system(size: 18, weight: .semibold)) }
}

public struct AlertDialogDescription: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).font(.system(size: 14)).foregroundStyle(.secondary) }
}

public struct AlertDialogAction: View {
  public enum Role { case `default`, destructive }
  let title: String; let role: Role; let action: () -> Void
  public init(_ title: String, role: Role = .default, action: @escaping () -> Void) {
    self.title = title; self.role = role; self.action = action
  }
  public var body: some View {
    Button(action: action) {
      Text(title).font(.system(size: 14, weight: .semibold))
    }
    .buttonStyle(role == .destructive ? .borderedProminent : .borderedProminent)
    .tint(role == .destructive ? .red : .blue)
  }
}

public struct AlertDialogCancel: View {
  let title: String; let action: () -> Void
  public init(_ title: String = "Cancel", action: @escaping () -> Void) { self.title = title; self.action = action }
  public var body: some View {
    Button(action: action) { Text(title) }
      .buttonStyle(.bordered)
  }
}
