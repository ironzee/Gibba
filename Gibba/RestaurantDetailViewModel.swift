//
//  RestaurantDetailViewModel.swift
//  Gibba
//
//  Created by Zulfiqur on 8/22/25.
//

import Foundation
import Foundation

@MainActor
final class RestaurantDetailViewModel: ObservableObject {
  @Published var restaurant: Restaurant
  @Published var selectedCategory: String = "All"
  @Published private(set) var favorites: Set<String> = []
  @Published private(set) var addedItems: Set<String> = []

  init(restaurant: Restaurant) { self.restaurant = restaurant }

  var categories: [String] {
    let cats = Set(restaurant.menu.map { $0.category })
    return ["All"] + cats.sorted()
  }

  var filteredMenu: [MenuItem] {
    guard selectedCategory != "All" else { return restaurant.menu }
    return restaurant.menu.filter { $0.category == selectedCategory }
  }

  func toggleFavorite(_ id: String) {
    if favorites.contains(id) { favorites.remove(id) } else { favorites.insert(id) }
  }

  func markAdded(_ id: String) {
    addedItems.insert(id)
    Task {
      try? await Task.sleep(nanoseconds: 2_000_000_000)
      await MainActor.run { self.addedItems.remove(id) }
    }
  }
}
