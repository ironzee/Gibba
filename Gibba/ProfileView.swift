//
//  ProfileView.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import SwiftUI

struct ProfileView: View {
  @StateObject private var vm = ProfileViewModel()

  private struct MenuItemModel: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
  }

  private var menuItems: [MenuItemModel] {
    [
      .init(icon: "mappin.and.ellipse", title: "Delivery Addresses", description: "Manage your saved addresses"),
      .init(icon: "creditcard",         title: "Payment Methods",    description: "Cards, Apple Pay, and more"),
      .init(icon: "heart.fill",         title: "Favorite Restaurants", description: "Your liked restaurants"),
      .init(icon: "star.fill",          title: "My Reviews",         description: "Reviews you've written"),
      .init(icon: "gift.fill",          title: "Loyalty Program",    description: "\(vm.user.loyaltyPoints) points available"),
      .init(icon: "bell.fill",          title: "Notifications",      description: "Order updates and offers"),
      .init(icon: "questionmark.circle",title: "Help & Support",     description: "Get help with your orders"),
      .init(icon: "gearshape.fill",     title: "Settings",           description: "Account and app preferences")
    ]
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 16) {

        // MARK: Profile Header
        VStack(spacing: 16) {
          HStack(spacing: 12) {
            ZStack {
              Circle()
                .fill(LinearGradient(colors: [.orange.opacity(0.75), .red.opacity(0.75)],
                                     startPoint: .top, endPoint: .bottom))
                .frame(width: 80, height: 80)
                .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 4))
              Text("👤").font(.system(size: 40))
            }

            VStack(alignment: .leading, spacing: 4) {
              Text(vm.user.name).font(.system(size: 18, weight: .bold))
              Text(vm.user.email).font(.system(size: 13)).foregroundStyle(.secondary)
              Text("Member since \(vm.memberSinceString)")
                .font(.system(size: 11, weight: .medium))
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(AppColor.border))
            }

            Spacer()

            Button {
              // edit action
            } label: {
              Image(systemName: "square.and.pencil")
                .padding(10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border))
            }
            .buttonStyle(.plain)
          }

          // Stats
          HStack(spacing: 12) {
            StatBox(value: "\(vm.user.ordersCount)",    label: "Orders")
            StatBox(value: "\(vm.user.favoriteRestaurants)", label: "Favorites")
          }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppColor.border))
        .padding(.horizontal, 16)

        // MARK: Loyalty Card
        VStack(alignment: .leading, spacing: 10) {
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text("🎯 Loyalty Points").font(.system(size: 16, weight: .bold))
              Text("\(vm.user.loyaltyPoints) points")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.orange)
              Text("\(max(0, 1000 - vm.user.loyaltyPoints)) points until free delivery for a month!")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text("🏆").font(.system(size: 36))
              .padding(8)
              .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
          }

          // Progress (choose one based on your AppProgressView API)
          // If AppProgressView expects 0…1:
          AppProgressView(value: .constant(vm.loyaltyProgress01), height: 12)

          // If it expects 0…100 instead, replace with:
          // AppProgressView(value: .constant(vm.loyaltyProgressPercent), height: 12)
        }
        .padding(16)
        .background(
          LinearGradient(colors: [.orange.opacity(0.18), .red.opacity(0.18)],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
          .blendMode(.plusLighter)
        )
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppColor.border))
        .padding(.horizontal, 16)

        // MARK: Menu Items
        VStack(spacing: 0) {
          ForEach(menuItems.indices, id: \.self) { i in
            let item = menuItems[i]
            Button {
              // route to destination
            } label: {
              HStack(spacing: 12) {
                Image(systemName: item.icon)
                  .frame(width: 36, height: 36)
                  .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                  .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColor.border))
                VStack(alignment: .leading, spacing: 2) {
                  Text(item.title).font(.system(size: 15, weight: .medium))
                  Text(item.description).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
              }
              .contentShape(Rectangle())
              .padding(12)
              .background(.ultraThinMaterial)
            }
            .buttonStyle(.plain)

            if i != menuItems.count - 1 { SeparatorView() }
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border))
        .padding(.horizontal, 16)

        // MARK: Recent Activity (ported from TSX)
        VStack(alignment: .leading, spacing: 12) {
          Text("Recent Activity")
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 4)

          VStack(spacing: 8) {
            ForEach(vm.recent) { item in
              RecentActivityRow(item: item)
            }
          }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppColor.border))
        .padding(.horizontal, 16)

        // MARK: Sign out
        Button(role: .destructive) {
          vm.signOut()
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "rectangle.portrait.and.arrow.right.fill")
            Text("Sign Out").font(.system(size: 15, weight: .semibold))
          }
          .frame(maxWidth: .infinity)
          .padding(14)
          .background(Color.red.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
        }
        .tint(.red)
        .padding(.horizontal, 16)

        Text("App Version 2.1.0 • Made with ❤️ in Morocco")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
          .padding(.bottom, 24)
      }
      .padding(.top, 12)
    }
  }
}

private struct StatBox: View {
  let value: String
  let label: String
  var body: some View {
    VStack(spacing: 2) {
      Text(value).font(.system(size: 22, weight: .bold))
      Text(label).font(.system(size: 12)).foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding(12)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColor.border))
  }
}

private struct RecentActivityRow: View {
  let item: RecentActivity

  var iconView: some View {
    switch item.kind {
    case .delivered:
      return AnyView(
        ZStack {
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.green.opacity(0.8))
            .frame(width: 40, height: 40)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.5)))
          Text("✓").font(.system(size: 16, weight: .bold)).foregroundStyle(.green.opacity(0.1).blendMode(.plusDarker))
          // Simple check mark with green tile (mirrors TSX feel)
          Text("✓").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
        }
      )
    case .favorited:
      return AnyView(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.orange.opacity(0.8))
          .frame(width: 40, height: 40)
          .overlay(Image(systemName: "heart.fill").foregroundStyle(.orange.opacity(0.9).blendMode(.plusDarker)))
          .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.5)))
      )
    case .review:
      return AnyView(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.yellow.opacity(0.8))
          .frame(width: 40, height: 40)
          .overlay(Image(systemName: "star.fill").foregroundStyle(.yellow.opacity(0.9).blendMode(.plusDarker)))
          .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.5)))
      )
    }
  }

  var body: some View {
    HStack(spacing: 12) {
      iconView

      VStack(alignment: .leading, spacing: 2) {
        Text(item.title).font(.system(size: 14, weight: .semibold))
        Text(item.subtitle).font(.system(size: 12)).foregroundStyle(.secondary)
      }
      Spacer()
      if let trailing = item.trailing {
        Text(trailing)
          .font(.system(size: 12))
          .padding(.horizontal, 8).padding(.vertical, 4)
          .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
          .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColor.border))
      }
    }
    .padding(10)
    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border))
  }
}
