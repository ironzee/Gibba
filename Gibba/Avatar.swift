//
//  Avatar.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct Avatar<Placeholder: View>: View {
  public enum Size { case xs, sm, md, lg, xl
    var points: CGFloat { switch self { case .xs: 20; case .sm: 32; case .md: 40; case .lg: 56; case .xl: 72 } }
  }

  let url: URL?
  let size: Size
  let placeholder: Placeholder

  public init(url: URL?, size: Size = .md, @ViewBuilder placeholder: () -> Placeholder) {
    self.url = url; self.size = size; self.placeholder = placeholder()
  }

  public var body: some View {
    ZStack {
      if let url = url {
        AsyncImage(url: url) { phase in
          switch phase {
            case .success(let image): image.resizable().scaledToFill()
            case .failure(_), .empty: placeholderView
            @unknown default: placeholderView
          }
        }
      } else { placeholderView }
    }
    .frame(width: size.points, height: size.points)
    .clipShape(Circle())
    .overlay(Circle().stroke(Color.black.opacity(0.08)))
  }

  private var placeholderView: some View {
    ZStack { placeholder.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(.systemGray5)) }
  }
}

public struct AvatarFallback: View {
  let text: String
  public init(_ text: String) { self.text = text }
  public var body: some View { Text(text).font(.system(size: 14, weight: .medium)) }
}

