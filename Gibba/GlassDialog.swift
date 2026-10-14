//
//  GlassDialog.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

//
//  GlassDialog.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct GlassDialog<DialogContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let content: () -> DialogContent

  public init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> DialogContent) {
    self._isPresented = isPresented
    self.content = content
  }

  public func body(content base: Content) -> some View {
    base
      .overlay {
        if isPresented {
          ZStack {
            // Dimmed backdrop
            Color.black.opacity(0.5)
              .ignoresSafeArea()
              .transition(.opacity)

            // Dialog body
            dialogBody
              .transition(.scale(scale: 0.95).combined(with: .opacity))
          }
        }
      }
      .animation(.easeInOut(duration: 0.2), value: isPresented)
  }

  private var dialogBody: some View {
    VStack(spacing: 12) {
      self.content()
    }
    .padding(24)
    .frame(maxWidth: 600)
    .background(
      // Glass card
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(.ultraThinMaterial)
        .overlay(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 12)
    )
    .overlay(alignment: .topTrailing) {
      Button(action: { isPresented = false }) {
        Image(systemName: "xmark")
          .font(.system(size: 14, weight: .semibold))
          .padding(8)
      }
      .buttonStyle(GlassButtonStyle(variant: .ghost, size: .sm))
      .accessibilityLabel("Close")
      .padding(8)
    }
    .padding(.horizontal, 16)
  }
}

public extension View {
  func glassDialog<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(GlassDialog(isPresented: isPresented, content: content))
  }
}
