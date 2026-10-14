//
//  SheetView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public enum SheetSide { case top, right, bottom, left }

public struct SheetView<Content: View>: View {
  @Binding var isPresented: Bool
  let side: SheetSide
  let content: Content
  public var width: CGFloat = 0.75 // for left/right
  public var background: Material = .ultraThin
  public var showsClose: Bool = true

  public init(isPresented: Binding<Bool>, side: SheetSide = .right, @ViewBuilder content: () -> Content) {
    self._isPresented = isPresented; self.side = side; self.content = content()
  }

  public var body: some View {
    GeometryReader { geo in
      ZStack(alignment: alignment) {
        if isPresented {
          Color.black.opacity(0.5)
            .ignoresSafeArea()
            .onTapGesture { withAnimation { isPresented = false } }
            .transition(.opacity)

          sheet(geo.size)
            .transition(transition)
        }
      }
      .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
  }

  @ViewBuilder private func sheet(_ size: CGSize) -> some View {
    let w = max(280, size.width * width)
    VStack(spacing: 0) {
      HStack {
        Spacer()
        if showsClose {
          Button { withAnimation { isPresented = false } } label: {
            Image(systemName: "xmark")
              .font(.system(size: 14, weight: .semibold))
              .padding(8)
              .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
          }
          .buttonStyle(.plain)
          .padding(12)
        }
      }
      content.padding(16)
      Spacer(minLength: 0)
    }
    .frame(
      width: (side == .left || side == .right) ? w : size.width,
      height: (side == .top || side == .bottom) ? min(size.height * 0.9, size.height) : size.height
    )
    .background(background, in: RoundedRectangle(cornerRadius: side == .top || side == .bottom ? 14 : 0))
    .overlay(
      RoundedRectangle(cornerRadius: side == .top || side == .bottom ? 14 : 0)
        .stroke(Color.black.opacity(0.08))
    )
  }

  private var alignment: Alignment {
    switch side {
      case .right: return .trailing
      case .left: return .leading
      case .top: return .top
      case .bottom: return .bottom
    }
  }

  private var transition: AnyTransition {
    switch side {
      case .right: return .move(edge: .trailing)
      case .left: return .move(edge: .leading)
      case .top: return .move(edge: .top)
      case .bottom: return .move(edge: .bottom)
    }
  }
}
