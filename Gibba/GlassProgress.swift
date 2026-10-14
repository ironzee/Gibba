//
//  GlassProgress.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct GlassProgress: View {
  let value: Double // 0...100
    var height: CGFloat = 10

  public init(value: Double) { self.value = max(0, min(100, value)) }

  public var body: some View {
    ZStack(alignment: .leading) {
      Capsule().fill(Theme.ColorToken.card.opacity(0.5))
        .overlay(Capsule().stroke(Theme.ColorToken.border))
      Capsule().fill(LinearGradient(colors: [.green.opacity(0.6), .blue.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
        .frame(width: nil)
        .mask(
          GeometryReader { geo in
            Rectangle().frame(width: geo.size.width * value/100)
          }
        )
    }
    .frame(height: 12)
  }
}
