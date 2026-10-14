//
//  ProfileViewModel.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//
//

import Foundation

//struct UserProfile {
//  var name: String
//  var email: String
//  var memberSince: Date
//  var ordersCount: Int
//  var favoriteRestaurants: Int
//  var reviewsCount: Int
//  var loyaltyPoints: Int
//}

struct RecentActivity: Identifiable {
  enum Kind { case delivered, favorited, review }
  let id = UUID()
  let kind: Kind
  let title: String
  let subtitle: String
  let trailing: String? // e.g., price “85 MAD” or rating “★ 5.0”
}

@MainActor
final class ProfileViewModel: ObservableObject {
  @Published var user: UserProfile
  @Published var recent: [RecentActivity] = []

  init(
    user: UserProfile = .init(
      name: "Youssef Benali",
      email: "youssef.benali@email.com",
      memberSince: ISO8601DateFormatter().date(from: "2024-01-15T00:00:00Z") ?? Date(),
      ordersCount: 24,
      favoriteRestaurants: 8,
      reviewsCount: 12,
      loyaltyPoints: 450
    )
  ) {
    self.user = user
    // Mirror the TSX “Recent Activity”
    self.recent = [
      .init(kind: .delivered,  title: "Order delivered",     subtitle: "Riad Tajine • 2 hours ago",   trailing: "85 MAD"),
      .init(kind: .favorited,  title: "Added to favorites",  subtitle: "Atlas Mountains Kitchen • 1 day ago", trailing: nil),
      .init(kind: .review,     title: "Left a review",       subtitle: "Casablanca Bistro • 2 days ago",      trailing: "★ 5.0")
    ]
  }

  var memberSinceString: String {
    let df = DateFormatter(); df.dateFormat = "MMM yyyy"
    return df.string(from: user.memberSince)
  }

  var loyaltyProgress01: Double {
    // If AppProgressView expects 0…1, use this.
    // Free month at 1000 points (TSX used “550 until free month” with 450 points now).
    // To match TSX banner exactly: 450/1000 = 0.45
    // If your threshold is 1000, keep 1000; if it’s 1000-450=550 remaining, we’re fine.
    return min(Double(user.loyaltyPoints) / 1000.0, 1.0)
  }

  var loyaltyProgressPercent: Double {
    loyaltyProgress01 * 100.0
  }

  func signOut() {
    // hook: integrate auth later
  }
}
