//
//  DrawerSheet.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum DrawerEdge { case bottom, top, leading, trailing }

public struct DrawerSheet<Content: View>: View {
  @Binding var isPresented: Bool
  let edge: DrawerEdge
  let detents: [CGFloat] // 0...1 of screen height/width (for bottom/top use height; leading/trailing use width)
  let content: Content
  @GestureState private var dragOffset: CGFloat = 0

  public init(isPresented: Binding<Bool>, edge: DrawerEdge = .bottom, detents: [CGFloat] = [0.5, 0.9], @ViewBuilder content: () -> Content) {
    self._isPresented = isPresented; self.edge = edge; self.detents = detents.sorted(); self.content = content()
  }

  @State private var currentIndex: Int = 0

  public var body: some View {
    GeometryReader { geo in
      ZStack(alignment: alignment) {
        if isPresented {
          Color.black.opacity(0.45)
            .ignoresSafeArea()
            .onTapGesture { withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) { isPresented = false } }
            .transition(.opacity)

          drawer(geo: geo.size)
            .transition(transition(geo: geo.size))
        }
      }
      .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
  }

  @ViewBuilder private func drawer(geo: CGSize) -> some View {
    let axisLength: CGFloat = (edge == .bottom || edge == .top) ? geo.height : geo.width
    let size = detents[currentIndex] * axisLength
  
      // ... inside your ViewBuilder func drawer(geo: CGSize) -> some View { ... }

      // Update the updating block if you want clamped offsets (optional)
      let drag = DragGesture()
        .updating($dragOffset) { value, state, _ in
          switch edge {
          case .bottom:   state = max(0, value.translation.height)
          case .top:      state = min(0, value.translation.height)
          case .leading:  state = min(0, value.translation.width)
          case .trailing: state = max(0, value.translation.width)
          }
        }
        .onEnded { value in
          // Use **directional** delta (CGFloat), not magnitude
          let delta: CGFloat
          switch edge {
          case .bottom:   delta =  value.translation.height     // drag down to dismiss
          case .top:      delta = -value.translation.height     // drag up to dismiss
          case .trailing: delta =  value.translation.width      // drag right to dismiss
          case .leading:  delta = -value.translation.width      // drag left to dismiss
          }

          // Threshold as CGFloat
          let threshold: CGFloat = 120

          if delta > threshold {
            isPresented = false
            return
          }
        }


    let view = VStack(spacing: 0) {
      Capsule().fill(Color.secondary.opacity(0.4)).frame(width: 36, height: 5).padding(.top, 8).padding(.bottom, 8)
      content
        .padding(.bottom, 16)
    }
    .frame(
      width: (edge == .leading || edge == .trailing) ? size : nil,
      height: (edge == .bottom || edge == .top) ? size : nil
    )
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08)))
    .gesture(drag)

    switch edge {
      case .bottom: view.offset(y: dragOffset)
      case .top:    view.offset(y: dragOffset)
      case .leading:view.offset(x: dragOffset)
      case .trailing:view.offset(x: dragOffset)
    }
  }

  private var alignment: Alignment {
    switch edge {
      case .bottom: return .bottom
      case .top: return .top
      case .leading: return .leading
      case .trailing: return .trailing
    }
  }

  private func transition(geo: CGSize) -> AnyTransition {
    switch edge {
      case .bottom: return .move(edge: .bottom)
      case .top: return .move(edge: .top)
      case .leading: return .move(edge: .leading)
      case .trailing: return .move(edge: .trailing)
    }
  }
}
import CoreGraphics

extension CGSize {
  /// Euclidean length of the 2D vector
  var length: CGFloat { hypot(width, height) }
}
