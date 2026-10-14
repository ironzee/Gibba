//
//  AppSlider.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct AppSlider: View {
  @Binding var value: Double   // 0.0 ... 1.0
  public var step: Double = 0.0
  public var height: CGFloat = 6
  public var thumbSize: CGFloat = 22
  public var trackColor: Color = Color.black.opacity(0.12)
  public var fillColor: Color = .primary

  public init(value: Binding<Double>, step: Double = 0.0) {
    self._value = value; self.step = step
  }

  public var body: some View {
    GeometryReader { geo in
      let width = max(1, geo.size.width)
      ZStack(alignment: .leading) {
        Capsule().fill(trackColor).frame(height: height)
        Capsule()
          .fill(fillColor)
          .frame(width: CGFloat(value.clamped) * width, height: height)
        Circle()
          .fill(.background)
          .overlay(Circle().stroke(Color.black.opacity(0.1)))
          .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
          .frame(width: thumbSize, height: thumbSize)
          .offset(x: CGFloat(value.clamped) * (width - thumbSize))
          .gesture(DragGesture(minimumDistance: 0)
            .onChanged { g in
              let x = min(max(0, g.location.x), width)
              var raw = Double(x / width)
              if step > 0 { raw = (raw/step).rounded() * step }
              value = raw.clamped
            })
      }
    }
    .frame(height: max(thumbSize, height))
  }
}

private extension Double { var clamped: Double { min(max(0, self), 1) } }
