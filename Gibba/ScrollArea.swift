//
//  ScrollArea.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct ScrollArea<Content: View>: View {
  let axes: Axis.Set
  let showsIndicators: Bool
  let content: Content

  public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
    self.axes = axes; self.showsIndicators = showsIndicators; self.content = content()
  }

  public var body: some View {
    ScrollView(axes, showsIndicators: showsIndicators) {
      content
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
  }
}
