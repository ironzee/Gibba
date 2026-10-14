//
//  Collapsible.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Collapsible<Trigger: View, Content: View>: View {
  @Binding var isOpen: Bool
  let trigger: Trigger
  let content: Content
  public init(isOpen: Binding<Bool>,
              @ViewBuilder trigger: () -> Trigger,
              @ViewBuilder content: () -> Content) {
    self._isOpen = isOpen; self.trigger = trigger(); self.content = content()
  }

  public var body: some View {
    VStack(spacing: 0) {
      Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isOpen.toggle() } }) {
        HStack { trigger; Spacer(); Image(systemName: "chevron.down").rotationEffect(.degrees(isOpen ? 180 : 0)) }
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .padding(.vertical, 12)

      if isOpen {
        VStack(alignment: .leading, spacing: 8) { content }
          .transition(.opacity.combined(with: .move(edge: .top)))
          .padding(.bottom, 12)
      }
    }
  }
}
