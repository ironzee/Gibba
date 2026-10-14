//
//  TabsView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

public struct TabItem: Identifiable, Hashable {
  public let id = UUID()
  public let title: String
  public let systemImage: String?
  public init(_ title: String, systemImage: String? = nil) {
    self.title = title; self.systemImage = systemImage
  }
}

public struct TabsView<Content: View>: View {
  @Binding var selection: Int
  let items: [TabItem]
  let content: Content
  public var equalsWidth: Bool = true
  public var underline: Bool = true

  public init(selection: Binding<Int>, items: [TabItem], equalsWidth: Bool = true, underline: Bool = true, @ViewBuilder content: () -> Content) {
    self._selection = selection
    self.items = items
    self.equalsWidth = equalsWidth
    self.underline = underline
    self.content = content()
  }

  public var body: some View {
    VStack(spacing: 0) {
      // Tab bar
      HStack(spacing: 6) {
        ForEach(items.indices, id: \.self) { i in
          Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) { selection = i }
          } label: {
            VStack(spacing: 6) {
              HStack(spacing: 6) {
                if let s = items[i].systemImage { Image(systemName: s) }
                Text(items[i].title)
              }
              .font(.system(size: 14, weight: selection == i ? .semibold : .medium))
              .foregroundStyle(selection == i ? .primary : .secondary)

              if underline {
                Rectangle()
                  .fill(selection == i ? Color.primary : .clear)
                  .frame(height: 2)
                  .animation(.easeInOut(duration: 0.2), value: selection)
              }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: equalsWidth ? .infinity : nil)
            .background(
              (selection == i ? Color.primary.opacity(0.08) : Color.clear),
              in: RoundedRectangle(cornerRadius: 10)
            )
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal, 8)
      .padding(.top, 8)
      .background(Color(.secondarySystemBackground))

      // Content
      ZStack {
        content
      }
    }
    .background(Color(.systemBackground))
  }
}
