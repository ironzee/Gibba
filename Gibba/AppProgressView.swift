//
//  AppProgressView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct AppProgressView: View {
  @Binding var value: Double // 0...100
  public var height: CGFloat = 8
  public var background: Color = Color.primary.opacity(0.2)
  public var fill: Color = .primary
  public var cornerRadius: CGFloat = 999

  public init(value: Binding<Double>, height: CGFloat = 8) {
    self._value = value; self.height = height
  }

  public var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .leading) {
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(background)
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(fill)
          .frame(width: max(0, min(1, value/100)) * geo.size.width)
          .animation(.easeInOut(duration: 0.2), value: value)
      }
    }
    .frame(height: height)
  }
}
