//
//  GlassMeter.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct GlassMeter: View {
  let value: Double     // current points
  let target: Double    // target points

  public init(value: Double, max target: Double) {
    self.value  = Swift.max(0, value)
    self.target = Swift.max(1, target)          // avoid divide-by-zero
  }

  public var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .leading) {
        // track
        RoundedRectangle(cornerRadius: 999, style: .continuous)
          .fill(Theme.card.opacity(0.6))
          .overlay(
            RoundedRectangle(cornerRadius: 999, style: .continuous)
              .stroke(Theme.border)
          )

        // fill
        let pct  = Swift.min(value / target, 1)          // 0...1
        let fill = CGFloat(pct) * geo.size.width

        RoundedRectangle(cornerRadius: 999, style: .continuous)
          .fill(LinearGradient(
            colors: [.orange.opacity(0.9), .red.opacity(0.9)],
            startPoint: .leading, endPoint: .trailing
          ))
          .frame(width: fill)
      }
    }
    .frame(height: 12)
  }
}
