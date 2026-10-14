//
//  NavigationBarView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import SwiftUI

struct NavigationBarView: View {
  @Binding var currentIndex: Int
  let cartCount: Int
  let onTap: (Int) -> Void

  private struct Item { let title: String; let icon: String }
  private let items: [Item] = [
    .init(title: "Home", icon: "house.fill"),
    .init(title: "Search", icon: "magnifyingglass"),
    .init(title: "Cart", icon: "bag.fill"),
    .init(title: "Profile", icon: "person.crop.circle.fill")
  ]

  var body: some View {
    VStack(spacing: 6) {
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(.ultraThinMaterial)
          .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColor.border))
          .shadow(color: .black.opacity(0.08), radius: 12, y: 6)

        HStack {
          ForEach(items.indices, id: \.self) { i in
            Button {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                currentIndex = i; onTap(i)
              }
            } label: {
              VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                  Image(systemName: items[i].icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(currentIndex == i ? .orange : .primary)
                  if i == 2, cartCount > 0 {
                    Text(cartCount > 99 ? "99+" : "\(cartCount)")
                      .font(.system(size: 10, weight: .bold))
                      .padding(.horizontal, 5).padding(.vertical, 2)
                      .background(Color.red, in: Capsule())
                      .foregroundStyle(.white)
                      .offset(x: 8, y: -6)
                  }
                }
                Text(items[i].title)
                  .font(.system(size: 11, weight: .medium))
                  .foregroundStyle(currentIndex == i ? .orange : .secondary)
              }
              .padding(.vertical, 10)
              .frame(maxWidth: .infinity)
              .background(
                RoundedRectangle(cornerRadius: 14)
                  .fill(currentIndex == i ? Color.orange.opacity(0.15) : Color.clear)
              )
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal, 8)
      }
      .frame(height: 66)
      .padding(.horizontal, 16)

      // home indicator spacer
      Rectangle().fill(Color.clear).frame(height: 8)
    }
    .frame(maxHeight: .infinity, alignment: .bottom)
    .ignoresSafeArea(edges: .bottom)
  }
}
