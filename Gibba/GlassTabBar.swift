//
//  GlassTabBar.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//
// GlassTabBar.swift
import SwiftUI

struct GlassTabBar: View {
  @Binding var selected: AppTab       // ⬅️ AppTab, not Int
  let cartCount: Int

  private struct Item { let title: String; let icon: String; let tab: AppTab }
  private let items: [Item] = [
    .init(title: "Home",    icon: "house.fill",                 tab: .home),
    .init(title: "Search",  icon: "magnifyingglass",            tab: .search),
    .init(title: "Cart",    icon: "bag.fill",                   tab: .cart),
    .init(title: "Profile", icon: "person.crop.circle.fill",    tab: .profile)
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
            let item = items[i]
            Button {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                selected = item.tab                     // ⬅️ set AppTab
              }
            } label: {
              VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                  Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(selected == item.tab ? .orange : .primary)
                  if item.tab == .cart, cartCount > 0 {
                    Text(cartCount > 99 ? "99+" : "\(cartCount)")
                      .font(.system(size: 10, weight: .bold))
                      .padding(.horizontal, 5).padding(.vertical, 2)
                      .background(Color.red, in: Capsule())
                      .foregroundStyle(.white)
                      .offset(x: 8, y: -6)
                  }
                }
                Text(item.title)
                  .font(.system(size: 11, weight: .medium))
                  .foregroundStyle(selected == item.tab ? .orange : .secondary)
              }
              .padding(.vertical, 10)
              .frame(maxWidth: .infinity)
              .background(
                RoundedRectangle(cornerRadius: 14)
                  .fill(selected == item.tab ? Color.orange.opacity(0.15) : Color.clear)
              )
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
          }
        }
        .padding(.horizontal, 8)
      }
      .frame(height: 66)
      .padding(.horizontal, 16)

      Rectangle().fill(Color.clear).frame(height: 8) // home indicator spacer
    }
    .frame(maxHeight: .infinity, alignment: .bottom)
    .ignoresSafeArea(edges: .bottom)
  }
}
