//
//  ToastCenter.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Toast: Identifiable, Equatable {
  public enum Style { case neutral, success, warning, error }
  public let id = UUID()
  public let title: String
  public let message: String?
  public let style: Style
  public let duration: TimeInterval
  public init(_ title: String, message: String? = nil, style: Style = .neutral, duration: TimeInterval = 2.5) {
    self.title = title; self.message = message; self.style = style; self.duration = duration
  }
}

public final class ToastCenter: ObservableObject {
  @Published public var queue: [Toast] = []
  public init() {}
  public func show(_ toast: Toast) {
    queue.append(toast)
    dismissAfter(toast)
  }
  private func dismissAfter(_ toast: Toast) {
    DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
      self.queue.removeAll { $0.id == toast.id }
    }
  }
}

public struct ToastHost<Content: View>: View {
  @StateObject var center = ToastCenter()
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    content
      .environmentObject(center)
      .overlay(alignment: .top) {
        VStack(spacing: 8) {
          ForEach(center.queue) { toast in
            ToastView(toast: toast)
              .transition(.move(edge: .top).combined(with: .opacity))
          }
        }
        .padding(.top, 12).padding(.horizontal, 12)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: center.queue)
      }
  }
}

public struct ToastView: View {
  let toast: Toast
  public var body: some View {
    HStack(alignment: .top, spacing: 10) {
      Image(systemName: icon).foregroundStyle(color)
      VStack(alignment: .leading, spacing: 2) {
        Text(toast.title).font(.system(size: 14, weight: .semibold))
        if let m = toast.message { Text(m).font(.system(size: 12)).foregroundStyle(.secondary) }
      }
      Spacer(minLength: 12)
    }
    .padding(12)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08)))
    .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
  }

  private var color: Color {
    switch toast.style { case .neutral: return .primary; case .success: return .green; case .warning: return .orange; case .error: return .red }
  }
  private var icon: String {
    switch toast.style { case .neutral: return "info.circle"; case .success: return "checkmark.circle"; case .warning: return "exclamationmark.triangle"; case .error: return "xmark.octagon" }
  }
}

// Convenience modifier
public extension View {
  func withToasts() -> some View { ToastHost { self } }
}
