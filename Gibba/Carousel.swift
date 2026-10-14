//
//  Carousel.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Carousel<Content: View>: View {
  public enum Orientation { case horizontal, vertical }
  let orientation: Orientation
  let content: Content
  @State private var index: Int = 0
  let count: Int
  public init(count: Int,
              orientation: Orientation = .horizontal,
              @ViewBuilder content: () -> Content) {
    self.count = count; self.orientation = orientation; self.content = content()
  }

  public var body: some View {
    ZStack {
      if orientation == .horizontal {
        TabView(selection: $index) {
          content
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      } else {
        ScrollViewReader { _ in
          ScrollView(.vertical, showsIndicators: false) { content }
        }
      }

      HStack {
        Button { withAnimation { index = max(index - 1, 0) } } label: {
          Image(systemName: "chevron.left")
        }
        .appButton(variant: .outline, size: .icon)
        .disabled(index == 0)
        Spacer()
        Button { withAnimation { index = min(index + 1, count - 1) } } label: {
          Image(systemName: "chevron.right")
        }
        .appButton(variant: .outline, size: .icon)
        .disabled(index >= count - 1)
      }
      .padding(.horizontal, 4)
      .frame(maxHeight: .infinity, alignment: .center)
    }
  }
}

public struct CarouselItem<Content: View>: View {
  let content: Content
  public init(@ViewBuilder content: () -> Content) { self.content = content() }
  public var body: some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .tag(UUID()) // For TabView identity when used in a ForEach of items, tag with index externally
      .padding(.horizontal, 16)
  }
}
