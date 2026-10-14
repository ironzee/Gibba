//
//  SkeletonView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct SkeletonView: View {
  public var cornerRadius: CGFloat = 12
  public var animated: Bool = true

  @State private var phase: CGFloat = -1

  public init(cornerRadius: CGFloat = 12, animated: Bool = true) {
    self.cornerRadius = cornerRadius; self.animated = animated
  }

  public var body: some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
      .fill(LinearGradient(stops: [
        .init(color: Color.gray.opacity(0.22), location: 0.0),
        .init(color: Color.gray.opacity(0.32), location: 0.5),
        .init(color: Color.gray.opacity(0.22), location: 1.0)
      ], startPoint: .leading, endPoint: .trailing))
      .mask(
        Rectangle()
          .fill(
            LinearGradient(colors: [.black.opacity(0.15), .black, .black.opacity(0.15)],
                           startPoint: .leading, endPoint: .trailing)
          )
          .offset(x: animated ? phase * 240 : 0)
      )
      .onAppear {
        guard animated else { return }
        withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
          phase = 1.5
        }
      }
  }
}

/// Quick skeleton lines stack
public struct SkeletonLines: View {
  public let rows: Int
  public var spacing: CGFloat = 10
  public init(rows: Int = 3, spacing: CGFloat = 10) { self.rows = rows; self.spacing = spacing }
  public var body: some View {
    VStack(alignment: .leading, spacing: spacing) {
      ForEach(0..<rows, id: \.self) { i in
        SkeletonView(cornerRadius: 8)
          .frame(height: i == 0 ? 16 : 12)
          .opacity(i == 0 ? 0.9 : 0.8)
      }
    }
  }
}
