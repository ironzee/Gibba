//
//  ResizablePanels.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum PanelDirection { case horizontal, vertical }

public struct ResizablePanelGroup: View {
  let direction: PanelDirection
  let panels: [AnyView]
  @State private var sizes: [CGFloat]

  public init(direction: PanelDirection = .horizontal,
              panels: [AnyView],
              initialFractions: [CGFloat]? = nil) {
    self.direction = direction
    self.panels = panels
    let count = max(1, panels.count)
    let base = (initialFractions?.count == count ? initialFractions! : Array(repeating: 1.0/CGFloat(count), count: count))
    let sum = base.reduce(0,+)
    _sizes = State(initialValue: base.map { $0 / max(0.0001, sum) })
  }

  public var body: some View {
    GeometryReader { geo in
      groupStack(total: direction == .horizontal ? geo.size.width : geo.size.height)
    }
  }

  @ViewBuilder private func groupStack(total: CGFloat) -> some View {
    if direction == .horizontal {
      HStack(spacing: 0) { panelsStack(total: total) }
    } else {
      VStack(spacing: 0) { panelsStack(total: total) }
    }
  }

  @ViewBuilder private func panelsStack(total: CGFloat) -> some View {
    ForEach(panels.indices, id: \.self) { i in
      panels[i]
        .frame(width: direction == .horizontal ? max(0, sizes[i] * total) : nil,
               height: direction == .vertical ? max(0, sizes[i] * total) : nil)
        .clipped()
      if i < panels.count - 1 {
        ResizableHandle(direction: direction) { delta in
          adjustSizes(at: i, delta: delta, total: total)
        }
      }
    }
  }

  private func adjustSizes(at index: Int, delta: CGFloat, total: CGFloat) {
    guard index >= 0 && index < sizes.count - 1 else { return }
    let fractionDelta = delta / max(1, total)
    let left = max(0.1, sizes[index] + fractionDelta)
    let right = max(0.1, sizes[index+1] - fractionDelta)
    let sum = left + right
    let combined = sizes[index] + sizes[index+1]
    sizes[index]   = left  / sum * combined
    sizes[index+1] = right / sum * combined
  }
}

public struct ResizableHandle: View {
  let direction: PanelDirection
  let onDrag: (CGFloat) -> Void

  public init(direction: PanelDirection, onDrag: @escaping (CGFloat) -> Void) {
    self.direction = direction; self.onDrag = onDrag
  }

  public var body: some View {
    Rectangle()
      .fill(Color.secondary.opacity(0.25))
      .frame(width: direction == .horizontal ? 1 : nil,
             height: direction == .vertical ? 1 : nil)
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .stroke(Color.secondary.opacity(0.35), lineWidth: 1)
          .frame(width: direction == .horizontal ? 6 : nil,
                 height: direction == .vertical ? 6 : nil)
      )
      .background(.ultraThinMaterial)
      .gesture(DragGesture(minimumDistance: 0)
        .onChanged { g in onDrag(direction == .horizontal ? g.translation.width : g.translation.height) }
        .onEnded { _ in })
      .frame(width: direction == .horizontal ? 12 : nil,
             height: direction == .vertical ? 12 : nil)
  }
}

// helper
public extension AnyView {
  static func panel<V: View>(_ v: V) -> AnyView { AnyView(v) }
}
