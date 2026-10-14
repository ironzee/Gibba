//
//  AspectRatioBox.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct AspectRatioBox<Content: View>: View {
  let ratio: CGFloat
  let content: Content
  public init(_ ratio: CGFloat, @ViewBuilder content: () -> Content) {
    self.ratio = ratio; self.content = content()
  }
  public var body: some View {
    ZStack { content.frame(maxWidth: .infinity, maxHeight: .infinity) }
      .aspectRatio(ratio, contentMode: .fit)
  }
}
