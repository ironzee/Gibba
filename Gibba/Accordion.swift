//
//  Accordion.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

// MARK: - Accordion Root
public struct Accordion<Content: View>: View {
  private let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View { VStack(spacing: 0) { content } }
}

// MARK: - Internal controller shared by Trigger/Content
public final class _AccordionState: ObservableObject {
  @Published public var isOpen: Bool
  public init(isOpen: Bool = false) { self.isOpen = isOpen }
}

// MARK: - Item
public struct AccordionItem<Content: View>: View {
  @StateObject private var state: _AccordionState
  private let content: Content
  private let hasBottomBorder: Bool

  public init(isOpen: Bool = false, hasBottomBorder: Bool = true, @ViewBuilder content: () -> Content) {
    _state = StateObject(wrappedValue: _AccordionState(isOpen: isOpen))
    self.content = content()
    self.hasBottomBorder = hasBottomBorder
  }

  public var body: some View {
    VStack(spacing: 0) {
      content
        .environmentObject(state)
      if hasBottomBorder {
        Divider().overlay(Color.black.opacity(0.1))
      }
    }
  }
}

// MARK: - Trigger
public struct AccordionTrigger<Label: View>: View {
  @EnvironmentObject private var state: _AccordionState
  private let label: Label

  public init(@ViewBuilder label: () -> Label) { self.label = label() }

  public var body: some View {
    Button {
      withAnimation(.easeInOut(duration: 0.2)) { state.isOpen.toggle() }
    } label: {
      HStack(alignment: .top, spacing: 12) {
        label
        Spacer()
        Image(systemName: "chevron.down")
          .rotationEffect(.degrees(state.isOpen ? 180 : 0))
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(.secondary)
          .offset(y: 2)
          .animation(.easeInOut(duration: 0.2), value: state.isOpen)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .padding(.vertical, 12)
  }
}

// MARK: - Content
public struct AccordionContent<Content: View>: View {
  @EnvironmentObject private var state: _AccordionState
  private let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }

  public var body: some View {
    Group {
      if state.isOpen {
        VStack(alignment: .leading, spacing: 8) { content }
          .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity))
          .padding(.bottom, 12)
      }
    }
    .animation(.easeInOut(duration: 0.2), value: state.isOpen)
  }
}
