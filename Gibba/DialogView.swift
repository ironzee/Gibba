//
//  DialogView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct DialogView<Content: View>: View {
  @Binding var isPresented: Bool
  let content: Content
  public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self._isPresented = isPresented; self.content = content()
  }
  public var body: some View {
    ZStack {
      if isPresented {
        Color.black.opacity(0.5).ignoresSafeArea().transition(.opacity)
        VStack(alignment: .leading, spacing: 16) {
          content
        }
        .frame(maxWidth: 640)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08)))
        .padding(16)
        .transition(.scale.combined(with: .opacity))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: isPresented)
  }
}

public struct DialogHeader<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { VStack(alignment: .leading, spacing: 8) { content } }
}
public struct DialogTitle: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).font(.system(size: 18, weight: .semibold)) }
}
public struct DialogDescription: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).font(.system(size: 14)).foregroundStyle(.secondary) }
}
public struct DialogFooter<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { HStack { Spacer(); content } }
}

