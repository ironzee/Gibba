//
//  Tooltip.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum TooltipPlacement { case top, bottom, leading, trailing }

public struct Tooltip<Content: View, Tip: View>: View {
  @State private var hovering = false
  let placement: TooltipPlacement
  let offset: CGFloat
  let content: Content
  let tip: Tip

  public init(placement: TooltipPlacement = .top,
              offset: CGFloat = 6,
              @ViewBuilder content: () -> Content,
              @ViewBuilder tip: () -> Tip) {
    self.placement = placement
    self.offset = offset
    self.content = content()
    self.tip = tip()
  }

  public var body: some View {
    ZStack {
      content
        .onHover { hovering = $0 }        // macOS / iPad pointer
        .onLongPressGesture(minimumDuration: 0.35) { hovering = true } // iOS
        .onTapGesture { if hovering { hovering = false } }

      GeometryReader { geo in
        if hovering {
          tipBody(size: geo.size)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .zIndex(1)
        }
      }
    }
    .animation(.easeInOut(duration: 0.16), value: hovering)
  }

  @ViewBuilder private func tipBody(size: CGSize) -> some View {
    VStack {
      if placement == .bottom { Spacer(minLength: 0) }
      HStack {
        if placement == .trailing { Spacer(minLength: 0) }
        LabelContainer { tip }
          .padding(.bottom, placement == .top ? offset : 0)
          .padding(.top, placement == .bottom ? offset : 0)
          .padding(.trailing, placement == .leading ? offset : 0)
          .padding(.leading, placement == .trailing ? offset : 0)
        if placement == .leading { Spacer(minLength: 0) }
      }
      if placement == .top { Spacer(minLength: 0) }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
  }

  private var alignment: Alignment {
    switch placement {
      case .top: return .top
      case .bottom: return .bottom
      case .leading: return .leading
      case .trailing: return .trailing
    }
  }
}

private struct LabelContainer<Tip: View>: View {
  let tip: () -> Tip
  var body: some View {
    tip()
      .font(.system(size: 12))
      .padding(.horizontal, 10).padding(.vertical, 6)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black.opacity(0.12)))
      .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
  }
}
