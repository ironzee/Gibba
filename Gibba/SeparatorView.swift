//
//  SeparatorView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct SeparatorView: View {
  public enum Orientation { case horizontal, vertical }
  public var orientation: Orientation = .horizontal
  public var color: Color = Color.secondary.opacity(0.3)

  public init(orientation: Orientation = .horizontal) { self.orientation = orientation }

  public var body: some View {
    Rectangle()
      .fill(color)
      .frame(width: orientation == .vertical ? 1 : nil,
             height: orientation == .horizontal ? 1 : nil)
  }
}
