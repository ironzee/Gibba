//
//  PopoverView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct PopoverView<Trigger: View, Content: View>: View {
  @State private var isPresented: Bool = false
  let trigger: Trigger
  let content: Content
  public let arrowEdge: Edge

  public init(arrowEdge: Edge = .top,
              @ViewBuilder trigger: () -> Trigger,
              @ViewBuilder content: () -> Content) {
    self.arrowEdge = arrowEdge
    self.trigger = trigger()
    self.content = content()
  }

  public var body: some View {
    Button { isPresented.toggle() } label: { trigger }
      .popover(isPresented: $isPresented, attachmentAnchor: .rect(.bounds), arrowEdge: arrowEdge) {
        VStack(alignment: .leading, spacing: 10) {
          content
        }
        .padding(12)
        .frame(maxWidth: 360)
        .background(.ultraThinMaterial)
        .presentationCompactAdaptation(.popover)
      }
  }
}
