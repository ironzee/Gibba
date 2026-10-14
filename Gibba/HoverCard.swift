//
//  HoverCard.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct HoverCard<Anchor: View, Content: View>: View {
  let anchor: Anchor
  let content: Content
  @State private var show = false
  public var delay: Double = 0.15

  public init(delay: Double = 0.15,
              @ViewBuilder anchor: () -> Anchor,
              @ViewBuilder content: () -> Content) {
    self.anchor = anchor(); self.content = content(); self.delay = delay
  }

  public var body: some View {
    anchor
      .onHover { hovering in
        if hovering {
          DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: 0.15)) { show = true }
          }
        } else {
          withAnimation(.easeInOut(duration: 0.15)) { show = false }
        }
      }
      .overlay(alignment: .bottomLeading) {
        if show {
          VStack(alignment: .leading, spacing: 8) { content }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.08)))
            .shadow(radius: 12)
            .offset(y: 10)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
      }
  }
}
