//
//  HomeViewModel.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

  // Inputs / State
  @Published var searchQuery: String = ""
  @Published var selectedCategory: String = "All"
  @Published var showFilters: Bool = false
  @Published var restaurants: [Restaurant]

  // MARK: Init (must inject your real restaurants)
  init(restaurants: [Restaurant]) {
    self.restaurants = restaurants
  }

  // MARK: Categories (name, icon, count)
  var categories: [(name: String, icon: String, count: Int)] {
    [
      ("All","🍽️",150),("Tajines","🍲",45),("Couscous","🍚",28),("Grilled","🔥",35),
      ("Seafood","🐟",22),("Street Food","🥙",40),("Desserts","🍯",32),
      ("Beverages","🍵",18),("Vegetarian","🥬",38)
    ]
  }

  var currentCategoryCount: Int {
    categories.first(where: { $0.name == selectedCategory })?.count ?? 0
  }

  // MARK: Derived lists

  var filtered: [Restaurant] {
    let q = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    // base: text search across name/cuisine/specialty
    let base = restaurants.filter { r in
      guard !q.isEmpty else { return true }
      if r.name.lowercased().contains(q) { return true }
      if r.cuisine.lowercased().contains(q) { return true }
      if (r.specialty ?? "").lowercased().contains(q) { return true }
      return false
    }

    // category filter (match category against menu categories or cuisine text)
    guard selectedCategory != "All" else { return base }
    return base.filter { r in
      r.menu.contains { $0.category.localizedCaseInsensitiveContains(selectedCategory) }
      || r.cuisine.localizedCaseInsensitiveContains(selectedCategory)
    }
  }

  var featured: [Restaurant] {
    Array(restaurants.filter { $0.rating >= 4.7 }.prefix(3))
  }

  var quickDelivery: [Restaurant] {
    restaurants.filter {
      // Parse "25-35 min" → 25 and compare
      let firstPart = $0.deliveryTime.split(separator: "-").first?
        .replacingOccurrences(of: " ", with: "") ?? ""
      let mins = Int(firstPart) ?? .max
      return mins <= 20
    }
  }

  // MARK: Quick actions behavior

  func filterQuickDelivery() {
    // Hook this to a dedicated fast-only toggle if you want;
    // keeping it a no-op preserves UI while you decide behavior.
  }

  func jumpToPremium() {
    // Hook to a premium collection/sort if desired.
  }
}
